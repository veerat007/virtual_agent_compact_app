class AskForMoreServiceDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  # init1         ['ask_additional_service']
  # init2         ['ask_additional_service']
  init1         AmiVoice::DialogModule::Settings.dialog_property.ask_for_more_service_dialog.prompts.init[0]
  init2         AmiVoice::DialogModule::Settings.dialog_property.ask_for_more_service_dialog.prompts.init[1]
  init3         AmiVoice::DialogModule::Settings.dialog_property.ask_for_more_service_dialog.prompts.init[2]
  #
  #== Properties
  #
  grammar_name           AmiVoice::DialogModule::Settings.dialog_property.ask_for_more_service_dialog.grammar_name #"yesno.gram" # TODO: Please set your grammar
  # max_retry              2
  confirmation_method    AmiVoice::DialogModule::Settings.dialog_property.ask_for_more_service_dialog.confirmation_option.parameterize.underscore.to_sym #:never

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
    if timeout?(session)
      increase_timeout(session)
      #if (retry_exceeded?(session)) || (total_exceeded?(session))
        ThankYouBlock
      #else
	    #  AskForMoreServiceDialog
      #end
    
    elsif rejected?(session)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        ThankYouBlock
      else
        AskForMoreServiceDialog
      end

    else # recognized
      if session["result"] =~ /yes/i
        AgentTransferBlock
      else
        increase_retry(session)
        ThankYouBlock
      end
    end
    # AskForMoreServiceDialog
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
