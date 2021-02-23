class AskForProductDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #== Prompts
  #init1         ['want_to_receive_service', 'ask_product']
  #init2         ['sorry_can_you_say_again']
  #init3         ['sorry_can_you_say_again']

  init1           AmiVoice::DialogModule::Settings.dialog_property.ask_for_product_dialog.prompts.init[0]
  init2           AmiVoice::DialogModule::Settings.dialog_property.ask_for_product_dialog.prompts.retry[0]
  init3           AmiVoice::DialogModule::Settings.dialog_property.ask_for_product_dialog.prompts.retry[0]

  #== Properties
  confirmation_method    :never

  #==Action

  action do |session|
    save_result(session)
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
          if !is_transfer_ivr(session)
            transfer_to_destination(session)
          else
            ### 
          end
        end
      else
        increase_retry(session)
        if (retry_exceeded?(session)) || (total_exceeded?(session))
          AgentTransferBlock
        else
          AskForProductDialog
        end
      end

    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
