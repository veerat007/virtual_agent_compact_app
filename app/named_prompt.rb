# coding: utf-8
#
module NamedPrompt
  extend ApplicationHelper
  extend AmiVoice::DialogModule::Utility

  class << self
    #
    # Please build your prompt using session object.  The return variable
    # should be String or Array of audio filenames.
    # Here is an example.
    #
    def speech_input_number_prompts session
      if session["id_number"].present? # != "failure" # session["nl_result"]["asr"]["utterance"].present?
        prompts = []
        session["id_number"].split("").each do |n|
          # if n.match?(/[0-9]/)
            prompts << "number/#{n}"
          # end
        end
        prompts.flatten!
      else
        prompts = [] 
      end
      prompts
    end

    def main_menu_init session
      prompts = []
      if total_retry(session) == 0
        prompts << AmiVoice::DialogModule::Settings.dialog_property.main_menu_dialog.prompts.init[0]
      else
        prompts << AmiVoice::DialogModule::Settings.dialog_property.main_menu_dialog.prompts.retry[0]
      end
      prompts
    end

    def ask_for_product_init session
      prompts = []
      prompts << AmiVoice::DialogModule::Settings.dialog_property.ask_for_product_dialog.prompts.init[0][0]
      prompts << get_intention_prompt(session)
      prompts << AmiVoice::DialogModule::Settings.dialog_property.ask_for_product_dialog.prompts.init[0][1]
      prompts
    end

    def ask_for_intent_init session
      prompts = []
      prompts << AmiVoice::DialogModule::Settings.dialog_property.ask_for_intent_dialog.prompts.init[0][0]
      prompts << get_product_prompt(session)
      prompts 
    end

    def confirm_intent_dialog_prompt session
      prompts = []
      prompts << AmiVoice::DialogModule::Settings.dialog_property.confirm_intent_dialog.prompts.init[0][0]
      prompts << get_intention_prompt(session)
      prompts << AmiVoice::DialogModule::Settings.dialog_property.confirm_intent_dialog.prompts.init[0][1]
      prompts << get_product_prompt(session)
      prompts << AmiVoice::DialogModule::Settings.dialog_property.confirm_intent_dialog.prompts.init[0][2]
      prompts
    end

    def confirm_intent_to_agent_dialog_prompt session
      prompts = []
      prompts << AmiVoice::DialogModule::Settings.dialog_property.confirm_intent_to_agent_dialog.prompts.init[0][0]
      prompts << get_intention_prompt(session)
      prompts << AmiVoice::DialogModule::Settings.dialog_property.confirm_intent_to_agent_dialog.prompts.init[0][1]
      prompts << get_product_prompt(session)
      prompts << AmiVoice::DialogModule::Settings.dialog_property.confirm_intent_to_agent_dialog.prompts.init[0][2]
      prompts
    end

    def announce_verify_question session
      prompts = []
      # product = get_product(session)
      product = session["identification_info"]["product"] # result from identification API
      if product.present? && product == "credit_card"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday']
        prompts << 'verify_question/birth_weekday' # prompt_list.simple
      elsif product.present? && product == "bank_account"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday', 'verify_question/have_atm_card']
        prompts << 'verify_question/birth_weekday' # prompt_list.simple
      elsif product.present? && product == "loan"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday']
        prompts << 'verify_question/birth_weekday' # prompt_list.simple
      end
      prompts
    end

    def number_prompts number
      prompts = []
      # number = number.to_s.gsub(",", "")
      if number == 0
        prompts << "number/0"
      else
        [1_000_000,100_000,10_000,1000,100,1].each do |n|
          x = number / n
          number = number % n
          unless x == 0
            if n == 1_000_000
            prompts << number_prompts((x/100)*100) if x >= 100
            prompts << "million" if x%100 == 0      # 100_000_000, 200_000_000, ...
            prompts << "number/%d" % ((x % 100) * n) if ((x % 100) * n) != 0
            else
            prompts << "number/%d" % (x * n)
            end
          end
        end
      end
      prompts
    end

    def currency_prompts number
      prompts = []
      if number.to_f < 0
        number = number.to_s.gsub!(/[-]/,'')
      end
      number = "%0.2f" % number
      number_arr = number.to_s.split('.')
      baht = number_arr[0].to_i
      satang = number_arr[1].to_i
      if baht > 0 || satang == 0
        prompts << number_prompts(baht)
        prompts << 'baht'
      end
      if satang > 0
        prompts << "number/#{satang}_satang"
      end
      prompts
    end
    
    def date_prompts date, use_day_of_week:false, convert_tomorrow:false, skip_full_year:true, skip_this_year:true, use_to_day:false, be:true
      if date.nil?
        AppLogger.warn "(#{__method__}) - nil is passed.  Retrun empty date prompts."
        return []
      elsif date.is_a? String
        if date.empty?
          AppLogger.warn "(#{__method__}) - empty string is passed.  Retrun empty date prompts."
          return []
        end
        begin
          the_day = Date.parse(date)
        rescue ArgumentError
          AppLogger.error "(#{__method__}) - #{$!}"
          return []
        end
      elsif date.respond_to?(:wday) and date.respond_to?(:day) and
            date.respond_to?(:month) and date.respond_to?(:year)
        the_day = date
      else
        raise AmiVoice::DialogModuleError.new("Invalid date object for date_prompts - #{date.inspect}")
      end

      prompts = []
      today = Date.today

      if the_day == today && use_to_day
        prompts << "date/ToDay"
      else
        # Day
        if use_day_of_week
          prompts << "date/day/wday_#{the_day.wday}" # Date Class return 0-6 for wday.
          prompts << ("number/%d" % the_day.day) # use the normal number audio for the day number
        else
          prompts << ("date/day_%02d" % the_day.day) # use the "day (วันที่)" version of the day number
        end
        # Month
        prompts << ("date/month/month_%02d" % the_day.month)

        unless skip_full_year
          if be
            prompts << ("date/BE")
          else
            prompts << ("date/AD")
          end
        end

        if skip_this_year && the_day.year == today.year # This year, skip the year parts for the audio prompts
          ; # omit the year audio part
        else
          # year in B.E.
          if be
            year = (the_day.year + 543) # convert the year from AD. to BE.
          else
            year = (the_day.year)
          end
          prompts += number_prompts(year)
        end
      end
      prompts
    end

  end
end
