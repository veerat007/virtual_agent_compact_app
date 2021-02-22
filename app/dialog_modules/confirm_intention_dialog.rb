class ConfirmIntentionDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['you_contact_intention', 'of_product', 'if_yes_please_wait']
  init2         ['sorry_ask_for_service_with_short_sentence']

  #
  #== Properties
  #
  grammar_name           "yesno.gram" # TODO: Please set your grammar
  #max_retry              2
  confirmation_method    :never

  #
  #==Action
  #

  action do |session|
    
    if timeout?(session)
      if !is_transfer_ivr(session)
        transfer_to_destination(session)
      else
        ### 
      end
      
    elsif rejected?(session)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        MainMenuDialog
      end

    else # recognized
      if session['result'] =~ /yes/i
        if !is_transfer_ivr(session)
          transfer_to_destination(session)
        else
          
        end
      else ## NO
        MainMenuDialog
      end

    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
