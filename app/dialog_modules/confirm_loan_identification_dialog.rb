class ConfirmLoanIdentificationDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  # init1         ['citizen_id_is', '%speech_input_number_prompts%', 'is_it_correct']
  # init2         ['citizen_id_is', '%speech_input_number_prompts%', 'is_it_correct']
  init1         { |session|
                  prompts = []
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.confirm_loan_identification_dialog.prompts.init[0][0]
                  prompts.push '%speech_input_number_prompts%'
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.confirm_loan_identification_dialog.prompts.init[0][1]
                  prompts.flatten!
                  prompts
                }
                
  init2         { |session|
                  prompts = []
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.confirm_loan_identification_dialog.prompts.init[1][0]
                  prompts.push '%speech_input_number_prompts%'
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.confirm_loan_identification_dialog.prompts.init[1][1]
                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           AmiVoice::DialogModule::Settings.dialog_property.confirm_loan_identification_dialog.grammar_name # "yesno.gram" # TODO: Please set your grammar
  # max_retry              2
  confirmation_method    AmiVoice::DialogModule::Settings.dialog_property.confirm_loan_identification_dialog.confirmation_option.parameterize.underscore.to_sym # :never

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
      if session["result"] =~ /yes/i
        VerificationQuestionDialog
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
