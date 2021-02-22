class AskForIntentDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['ask_intention']
  init2         ['sorry_ask_for_service_again']
  init3         ['sorry_ask_for_service_again']

  #
  #== Properties
  #
  #grammar_name           "yesno.gram" # TODO: Please set your grammar
  #max_retry              2
  confirmation_method    :never

  #
  #==Action
  #

  action do |session|

    if timeout?(session)
      increase_timeout(session)
      if (retry_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
	      AskForIntentDialog
      end
    
    elsif rejected?(session)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        AskForIntentDialog
      end

    else # recognized
      save_result(session)
      if contain_intention(session) ### Check contrains Intention.
        if has_one_intention(session) ### Check count intention = 1.
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
            ### go to Flow C
            AskForProductDialog
          end
        else ### has more than 1 intention
          AgentTransferBlock
        end
      elsif has_product(session) ### Check contrains Product.
        increase_retry(session)
        AskForIntentDialog
      else
        increase_retry(session)
        MainMenuDialog
      end
    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
