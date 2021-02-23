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
      if session["result"].present? # session["nl_result"]["asr"]["utterance"].present?
        prompt = []
        session["result"].each do |n|
          if n.match?(/[0-9]/)
            prompt << "numbers/#{n}"
          end
        end
        prompt.flatten!
      else
        prompt = [] 
      end
      prompt
    end

    def retry_prompt session
      prompts = []
      product = session["result_item"].present? ? session["result_item"]["product"] : ""
      intention = session["result_item"].present? ? session["result_item"]["intention"] : ""
      if product.blank? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif product.present? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif intention.present? && product.blank?
        prompts << 'sorry_can_you_say_again'
      end
      prompts
    end

    def reject_prompt session
      prompts = []
      product = session["result_item"].present? ? session["result_item"]["product"] : ""
      intention = session["result_item"].present? ? session["result_item"]["intention"] : ""
      if product.blank? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif product.present? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif intention.present? && product.blank?
        prompts << 'sorry_can_you_say_again'
      end
      prompts
    end

    def timeout_prompt session
      prompts = []
      product = session["result_item"].present? ? session["result_item"]["product"] : ""
      intention = session["result_item"].present? ? session["result_item"]["intention"] : ""
      if product.blank? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif product.present? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif intention.present? && product.blank?
        prompts << 'sorry_can_you_say_again'
      end
      prompts
    end
    
    def init_prompt session
      prompts = []
      product = session["result_item"].present? ? session["result_item"]["product"] : ""
      intention = session["result_item"].present? ? session["result_item"]["intention"] : ""
      if product.blank? && intention.blank?
        prompts << 'welcome'
      elsif product.present? && intention.blank?
        prompts << 'ask_intention'
      elsif intention.present? && product.blank?
        prompts << 'want_to_receive_service'
        prompts << 'ask_product'
      end
      prompts
    end

    def announce_verify_question session
      prompt = []
      # product = get_product(session)
      product = session["identification_info"]["product"] # result from identification API
      if product.present? && product == "credit_card"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday']
        prompt << 'verify_question/birth_weekday' # prompt_list.simple
      elsif product.present? && product == "bank_account"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday', 'verify_question/have_atm_card']
        prompt << 'verify_question/birth_weekday' # prompt_list.simple
      elsif product.present? && product == "loan"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday']
        prompt << 'verify_question/birth_weekday' # prompt_list.simple
      end
    end

    def number_prompts number
      prompts = []
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
    
  end
end
