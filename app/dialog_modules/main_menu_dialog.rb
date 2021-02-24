class MainMenuDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #== Prompts
  #init1         ['welcome']
  #init2         ['sorry_ask_for_service_with_short_sentence'] #['sorry_ask_for_service_again']
  #init3         ['sorry_ask_for_service_with_short_sentence'] #['sorry_ask_for_service_again']

  init1           AmiVoice::DialogModule::Settings.dialog_property.main_menu_dialog.prompts.init[0]
  init2           AmiVoice::DialogModule::Settings.dialog_property.main_menu_dialog.prompts.retry[0]
  init3           AmiVoice::DialogModule::Settings.dialog_property.main_menu_dialog.prompts.retry[0]

  #== Properties
  #grammar_name           "yesno.gram" # TODO: Please set your grammar
  max_retry              2
  timeout                "3s"
  complete_timeout       "0.8s"
  incomplete_timeout     "1.0s"
  speed_vs_accuracy      0.9
  max_speech_timeout     "10s"
  confidence_level       0.0
  confirmation_method    :never
  
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
	      MainMenuDialog
      end
    
    elsif rejected?(session)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        MainMenuDialog
      end

    else # recognized
      if contain_intention(session) ### Check contrains Intention.
        if has_one_intention(session) ### Check count intention = 1.
          if has_product(session) || belong_to_single_product(session)
            if dialog_property["confirmation_option"] == "never" || dialog_property["confirmation_option"].blank?
              transfer_to_destination(session)
            elsif dialog_property["confirmation_option"] == "always"
              go_confirmation()
            elsif dialog_property["confirmation_option"] == "confidence_base"
              if check_confidence(session, dialog_property['confirmation_confidence_threshold'])
                transfer_to_destination(session)
              else
                go_confirmation()
              end
            end
          else
            ### go to Flow C
            AskForProductDialog
          end
        else ### has more than 1 intention
          AgentTransferBlock
        end

      elsif has_product(session) ### Check contrains Product.
        increase_retry(session)
        if (retry_exceeded?(session)) || (total_exceeded?(session))
          AgentTransferBlock
        else
          AskForIntentDialog
        end
      else
        increase_retry(session)
        if (retry_exceeded?(session)) || (total_exceeded?(session))
          AgentTransferBlock
        else
          MainMenuDialog
        end
      end
    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
