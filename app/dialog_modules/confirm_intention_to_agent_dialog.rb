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
  max_retry              2
  confirmation_method    :always

  #
  #==Action
  #


#  before_generate_vxml do |session, params|
#    session.logger.info("before_generate_vxml")
#  end

#
# When you want to write your own rule for confirmation, you can
# change confirmation_method :server and uncomment below.
#
#  confirmation_method_server do |session, params|
#    session.logger.info("confirmation_method_server")
#    result = "accept" # or "confirm" or "reject"
#    prompts = []
#    [result, prompts]
#  end

#  before_confirmation do |session, params|
#    session.logger.info("before_confirmation")
#  end

  action do |session|
    # TODO: Please describe action here and set appropriate next dialog.
    # The last value should be next dialog.  But note that this block does not allow
    # to use 'return'.
    session.logger.info("action")
    ConfirmIntentionToAgentDialog
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
