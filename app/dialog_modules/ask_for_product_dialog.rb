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

  confirmation_init1    AmiVoice::DialogModule::Settings.dialog_property.ask_for_intent_dialog.prompts.confirm[0]

  #== Properties
  confirmation_method    AmiVoice::DialogModule::Settings.dialog_property.ask_for_product_dialog.confirmation_option.parameterize.underscore.to_sym

  #==Action
  
  action do |session|
  ##################### 
    dialog_property = get_dialog_property(session)
    save_result(session)
  #####################

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
        main_menu_property = AmiVoice::DialogModule::Settings.dialog_property.main_menu_dialog
        if main_menu_property["confirmation_option"] == "never" || main_menu_property["confirmation_option"].blank?
          transfer_to_destination(session)
        elsif main_menu_property["confirmation_option"] == "always"
          go_confirmation(session)
        elsif main_menu_property["confirmation_option"] == "confidence_base"
          if check_confidence(session, main_menu_property['confirmation_confidence_threshold'])
            transfer_to_destination(session)
          else
            go_confirmation(session)
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
