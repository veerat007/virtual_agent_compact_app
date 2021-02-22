class ConfirmIntentionToAgentDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['transfer_to_agent_for_service', 'of_product', 'if_yes_please_wait']

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
      #increase_timeout(session)
      AgentTransferBlock
      
    elsif rejected?(session)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        MainMenuDialog
      end

    else # recognized
      if session['result'] =~ /yes/i
        AgentTransferBlock
      else ## NO
        MainMenuDialog
      end

    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
