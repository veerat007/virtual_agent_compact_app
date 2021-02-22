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
      if session["nl_result"]["asr"]["utterance"].present?
        "#{session["nl_result"]["asr"]["utterance"]}"
          prompt = []
          session["nl_result"]["asr"]["utterance"].each do |n|
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
      product = get_product(session)
      if product.present? && product == "credit_card"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday']
        prompt << 'verify_question/date_of_birth' # prompt_list.simple
      elsif product.present? && product == "bank_account"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday', 'verify_question/have_atm_card']
        prompt << 'verify_question/date_of_birth' # prompt_list.simple
      elsif product.present? && product == "loan"
        prompt_list = ['verify_question/date_of_birth', 'verify_question/phone_number', 'verify_question/birth_weekday']
        prompt << 'verify_question/date_of_birth' # prompt_list.simple
      end
    end
    
  end
end
