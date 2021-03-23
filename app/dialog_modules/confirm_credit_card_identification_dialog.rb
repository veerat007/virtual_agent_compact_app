class ConfirmCreditCardIdentificationDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  before_generate_vxml {|session, params|
    @dialog_property = get_dialog_property(session)
  }

  #
  #== Prompts
  #
  init1         { |session|
                  prompts = []
                  prompts.push @dialog_property["prompts"]["init"][0][0]
                  prompts.push '%speech_input_number_prompts%'
                  prompts.push @dialog_property["prompts"]["init"][0][1]
                  prompts.flatten!
                  prompts
                }

  init2         { |session|
                  prompts = []
                  prompts.push @dialog_property["prompts"]["init"][1][0]
                  prompts.push '%speech_input_number_prompts%'
                  prompts.push @dialog_property["prompts"]["init"][1][1]
                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           "yesno.gram"
  confirmation_method    get_confirmation_dialog(ConfirmCreditCardIdentificationDialog.name) # :never

  #
  #==Action
  #
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
	      CreditCardIdentificationDialog
      end
    
    elsif rejected?(session, true)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        CreditCardIdentificationDialog
      end

    else # recognized
      if session["result"] =~ /yes/i
        VerificationQuestionDialog
      else
        increase_retry(session)
        if (retry_exceeded? session) || (total_exceeded? session)
          AgentTransferBlock
        else
          CreditCardIdentificationDialog
        end
      end
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
