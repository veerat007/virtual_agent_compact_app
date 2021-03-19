class AskForProductDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  before_generate_vxml {|session, params|
    @dialog_property = get_dialog_property(session)
  }

  #== Prompts
  init1           ['%ask_for_product_init%']
  init2           ['%action_prompt%']

  confirmation_init1    {|session|
                            prompt = []
                            if @dialog_property.present?
                                    prompt << @dialog_property["prompts"]["confirm"][0]
                            end
                            prompt.flatten!
                            prompt
                        }

  #== Properties
  confirmation_method    get_confirmation_dialog(AskForProductDialog.name)

  #==Action
  
  action do |session|
  ##################### 
    save_result(session)
  #####################

    if timeout?(session)
      increase_timeout(session)
      if (timeout_exceeded?(session)) || (total_exceeded?(session))
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
        main_menu_property = get_dialog_property(session, MainMenuDialog.name)
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
