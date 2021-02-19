# coding: utf-8
#
module NamedPrompt
  extend AmiVoice::DialogModule::Utility

  class << self
    #
    # Please build your prompt using session object.  The return variable
    # should be String or Array of audio filenames.
    # Here is an example.
    #
    def speech_input_number_prompts session
      if session["nl_result"]["asr"]["utterance"]
        []
      else
        "#{session["nl_result"]["asr"]["utterance"]}"
          prompt = []
          session["nl_result"]["asr"]["utterance"].each do |n|
            if n.match?(/[0-9]/)
              prompt << "numbers/#{n}"
            end
          end
          prompt.flatten!
      end
      prompt
    end

    def reject_prompt session
      prompts = []
      product = get_product(session)
      intention = get_intention(session)
      if product.blank? && intention.blank?
        prompts << 'sorry_ask_for_service_again'
      elsif product.present?
        prompts << 'sorry_ask_for_service_again'
      elsif intention.present?
        prompts << 'sorry_ask_for_service_again'
      end
      prompts
    end

    def init_prompt session
      prompts = []
      product = get_product(session)
      intention = get_intention(session)
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
  end
end
