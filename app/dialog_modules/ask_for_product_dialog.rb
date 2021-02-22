class AskForProductDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['want_to_receive_service', 'ask_product']
  init2         ['sorry_can_you_say_again']
  init3         ['sorry_can_you_say_again']

  #
  #== Properties
  #
  #grammar_name           "yesno.gram" # TODO: Please set your grammar
  #max_retry              2
  confirmation_method    :nerver

  #
  #==Action
  #

  action do |session|

    if timeout?(session)
      increase_timeout(session)
      if (retry_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
	      AskForProductDialog
      end
    
    elsif rejected?(session)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        AskForProductDialog
      end

    else # recognized
      if has_product(session) || belong_to_single_product(session)
        if AmiVoice::DialogModule::Settings.confirm_intention_always
          ### go to Flow E
          ConfirmIntentionDialog
        else
          ### go to Flow D
          if !is_transfer_ivr
            transfer_to_destination()
          else
            ### 
          end
        end
      else
        AskForIntentDialog
      end

    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
