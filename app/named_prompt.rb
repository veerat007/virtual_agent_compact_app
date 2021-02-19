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
  end
end
