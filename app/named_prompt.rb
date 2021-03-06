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
    def speech_input_iden_number_prompts session
      if session["result_item"]["iden_id"].present? # != "failure" # session["nl_result"]["asr"]["utterance"].present?
        prompts = []
        session["result_item"]["iden_id"].split("").each do |n|
          prompts << "number/#{n}"
        end
        prompts.flatten!
      else
        prompts = [] 
      end
      prompts
    end

    def action_prompt session
      prompts = []
      dialog_property = DIALOG_PROPERTY
      if session['action_state'] == "timeout"
        prompts << dialog_property[session["dialog_name"]]["prompts"]["timeout"]
      elsif session['action_state'] == "reject"
        prompts << dialog_property[session["dialog_name"]]["prompts"]["reject"]
      else 
        prompts << dialog_property[session["dialog_name"]]["prompts"]["retry"]
      end
      prompts
    end

    def main_menu_init session
      prompts = []
      if total_retry(session) == 0
        prompts << DIALOG_PROPERTY["main_menu_dialog"]["prompts"]["init"][0]
      else
        prompts << DIALOG_PROPERTY["confirm_intent_dialog"]["prompts"]["retry"][0]
      end
      prompts
    end

    def ask_for_product_init session
      prompts = []
      prompts << DIALOG_PROPERTY["ask_for_product_dialog"]["prompts"]["init"][0][0]
      prompts << get_intention_prompt(session)
      prompts << DIALOG_PROPERTY["ask_for_product_dialog"]["prompts"]["init"][0][1]
      prompts
    end

    def ask_for_intent_init session
      prompts = []
      prompts << DIALOG_PROPERTY["ask_for_intent_dialog"]["prompts"]["init"][0][0]
      prompts << "product/#{get_product(session)}" #get_product_prompt(session)
      prompts 
    end

    def confirm_intent_dialog_prompt session
      prompts = []
      prompts << DIALOG_PROPERTY["confirm_intent_dialog"]["prompts"]["init"][0][0]
      prompts << get_intention_prompt(session)
      prompts << DIALOG_PROPERTY["confirm_intent_dialog"]["prompts"]["init"][0][1]
      prompts << "product/#{get_product(session)}" #get_product_prompt(session)
      prompts << DIALOG_PROPERTY["confirm_intent_dialog"]["prompts"]["init"][0][2]
      prompts
    end

    def confirm_intent_to_agent_dialog_prompt session
      prompts = []
      prompts << DIALOG_PROPERTY["confirm_intent_to_agent_dialog"]["prompts"]["init"][0][0]
      prompts << get_intention_prompt(session)
      prompts << DIALOG_PROPERTY["confirm_intent_to_agent_dialog"]["prompts"]["init"][0][1]
      prompts << "product/#{get_product(session)}" #get_product_prompt(session)
      prompts << DIALOG_PROPERTY["confirm_intent_to_agent_dialog"]["prompts"]["init"][0][2]
      prompts
    end

    def announce_verify_question session
      prompts = []
      intention = session["result_item"]["intention"].last
      prompt_list = INTENTION_LIST["code_#{intention}"]["verification"]["prompts"]
      puts "\n==========[announce_verify_question]===== session_max_count: #{session["max_count"].inspect} ===== ||||| ===== used_question: #{session["used_question"].inspect}\n"
      if session["max_count"].nil?
        session["used_question"] = []
        random_result = prompt_list.sample
        prompts << random_result
        session["used_question"] << random_result #prompts.last
        puts "\n==========[IF - announce_verify_question]========== used_question: #{session["used_question"].inspect}"
        puts "==========[IF - announce_verify_question]========== random_result: #{random_result.inspect}"
        puts "==========[IF - announce_verify_question]========== prompts      : #{prompts.inspect}\n"
      else
        session["used_question"].each do |u|
          prompt_list.delete(u)
        end
        random_result = prompt_list.sample
        prompts << random_result
        puts "\n==========[ELSE - announce_verify_question]========== used_question: #{session["used_question"].inspect}"
        puts "==========[ELSE - announce_verify_question]========== random_result: #{random_result.inspect}"
        puts "==========[ELSE - announce_verify_question]========== prompts      : #{prompts.inspect}\n"
        session["used_question"] << random_result #prompts.last
      end
      prompts.flatten!
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
