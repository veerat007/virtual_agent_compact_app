class BankAccountIdentificationDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  # init1         ['ask_account_id']
  # init2         ['sorry_can_say_account_id_again']
  init1         AmiVoice::DialogModule::Settings.dialog_property.bank_account_identification_dialog.prompts.init[0]
  init2         AmiVoice::DialogModule::Settings.dialog_property.bank_account_identification_dialog.prompts.init[1]
  # init3         AmiVoice::DialogModule::Settings.dialog_property.bank_account_identification_dialog.prompts.init[1]

  #
  #== Properties
  #
  grammar_name           AmiVoice::DialogModule::Settings.dialog_property.bank_account_identification_dialog.grammar_name # "10digits.gram" # TODO: Please set your grammar
  # max_retry              2
  confirmation_method    AmiVoice::DialogModule::Settings.dialog_property.bank_account_identification_dialog.confirmation_option.parameterize.underscore.to_sym #:never

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
      if (retry_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
	      BankAccountIdentificationDialog
      end
    
    elsif rejected?(session, true)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        BankAccountIdentificationDialog
      end

    else # recognized
      if session[:result] != 'failure'
        # go to Flow I

        ##### CALL BANK ACCOUNT IDENTIFICATION API #####
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_ident")
        response = Net::HTTP.post_form(uri, "product" => session["result_item"]["product"], "account_no" => session["result"])
        session["identification_info"] = JSON.parse(response.body)
        if session["identification_info"]["product"] == session["result_item"]["product"] && session["identification_info"]["bank_account_id"] == session["result"]
          session["id_number"] = session["result"]
          ConfirmBankAccountIdentificationDialog
        else
          # AgentTransferBlock
          increase_retry(session)
          if (retry_exceeded? session) || (total_exceeded? session)
            AgentTransferBlock
          else
            BankAccountIdentificationDialog
          end
        end
      else
        increase_retry(session)
        if (retry_exceeded? session) || (total_exceeded? session)
          AgentTransferBlock
        else
          BankAccountIdentificationDialog
        end
      end
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
