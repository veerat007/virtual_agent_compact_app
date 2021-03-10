class ConfirmIntentionDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #== Prompts
  init1           ['%confirm_intent_dialog_prompt%']

  #== Properties
  grammar_name           "yesno.gram" # TODO: Please set your grammar
  confirmation_method    :never

  #==Action

  action do |session|
    
    if timeout?(session)
      transfer_to_destination(session)
      
    elsif rejected?(session, true)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        session["action_state"] = ""
        session["result_item"]["product"] = ""
        session["result_item"]["intention"] = ""
        MainMenuDialog
      end

    else # recognized
      if session['result'] =~ /yes/i
        transfer_to_destination(session)
      else ## NO
        increase_retry(session)
        if (retry_exceeded?(session)) || (total_exceeded?(session))
          AgentTransferBlock
        else
          session["action_state"] = ""
          session["result_item"]["product"] = ""
          session["result_item"]["intention"] = ""
          MainMenuDialog
        end
      end

    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
