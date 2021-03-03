class LoanIdentificationDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  # init1         ['ask_citizen_id']
  # init2         ['sorry_can_say_ask_citizen_id_again']
  init1         AmiVoice::DialogModule::Settings.dialog_property.loan_identification_dialog.prompts.init[0]
  init2         AmiVoice::DialogModule::Settings.dialog_property.loan_identification_dialog.prompts.init[1]
  # init3         AmiVoice::DialogModule::Settings.dialog_property.loan_identification_dialog.prompts.init[1]

  # retry1        ['sorry_i_cannot_understand_you',
  #                'can_you_say_yes_or_no_again']
  # retry2        ['sorry_i_cannot_understand_you_again',
  #                'can_you_say_again']

  # timeout1      ['sorry_i_cannot_hear_you',
  #                'can_you_say_yes_or_no_again']
  # timeout2      ['sorry_i_cannot_hear_you_again',
  #                'can_you_say_again']

  # reject1       ['can_you_say_yes_or_no_again']
  # reject2       ['can_you_say_again']

  # confirmation_init1    ['%speech_input_number_prompts%', 'is_it_correct']
  # confirmation_retry1   ['sorry_i_cannot_understand_you',
  #                        '%speech_input_number_prompts%',
  #                        'is_it_right']
  # confirmation_timeout1 ['sorry_i_cannot_hear_you',
  #                        '%speech_input_number_prompts%',
  #                        'is_it_right']

  #
  #== Properties
  #
  grammar_name           AmiVoice::DialogModule::Settings.dialog_property.loan_identification_dialog.grammar_name #"13digits.gram" # TODO: Please set your grammar
  # max_retry              2
  confirmation_method    AmiVoice::DialogModule::Settings.dialog_property.loan_identification_dialog.confirmation_option.parameterize.underscore.to_sym #:never

  #
  #==Action
  #


#  before_generate_vxml do |session, params|
#    session.logger.info("before_generate_vxml")
#  end

#
# When you want to write your own rule for confirmation, you can
# change confirmation_method :server and uncomment below.
#
#  confirmation_method_server do |session, params|
#    session.logger.info("confirmation_method_server")
#    result = "accept" # or "confirm" or "reject"
#    prompts = []
#    [result, prompts]
#  end

#  before_confirmation do |session, params|
#    session.logger.info("before_confirmation")
#  end

  action do |session|
    # TODO: Please describe action here and set appropriate next dialog.
    # The last value should be next dialog.  But note that this block does not allow
    # to use 'return'.
    session.logger.info("action")
    # LoanIdentificationDialog
    if timeout?(session)
      increase_timeout(session)
      if (retry_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
	      LoanIdentificationDialog
      end
    
    elsif rejected?(session, true)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        LoanIdentificationDialog
      end

    else # recognized
      if session[:result] != 'failure'
        # go to Flow I

        ##### CALL LOAN IDENTIFICATION API #####
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_ident")
        response = Net::HTTP.post_form(uri, "product" => session["result_item"]["product"], "citizen_id" => session["result"])
        session["identification_info"] = JSON.parse(response.body)
        if session["identification_info"]["product"] == session["result_item"]["product"] && session["identification_info"]["citizen_id"] == session["result"]
          session["id_number"] = session["result"]
          ConfirmLoanIdentificationDialog
        else
          # AgentTransferBlock
          increase_retry(session)
          if (retry_exceeded? session) || (total_exceeded? session)
            AgentTransferBlock
          else
            LoanIdentificationDialog
          end
        end
      else
        increase_retry(session)
        if (retry_exceeded? session) || (total_exceeded? session)
          AgentTransferBlock
        else
          LoanIdentificationDialog
        end
      end
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
