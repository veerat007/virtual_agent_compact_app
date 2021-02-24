class CreditCardIdentificationDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['ask_credit_card_id',]
  init2         ['sorry_can_say_credit_card_id_again']

  # retry1        ['sorry_can_say_credit_card_id_again']
  # retry2        ['sorry_can_say_credit_card_id_again']

  # timeout1      ['sorry_can_say_credit_card_id_again']
  # timeout2      ['sorry_can_say_credit_card_id_again']

  # reject1       ['sorry_can_say_credit_card_id_again']
  # reject2       ['sorry_can_say_credit_card_id_again']

  # confirmation_init1    ['credit_card_id_is', '%speech_input_number_prompts%', 'is_it_correct']
  # confirmation_retry1   ['sorry_can_say_credit_card_id_again']
  # confirmation_timeout1 ['sorry_can_say_credit_card_id_again']

  #
  #== Properties
  #
  grammar_name           "16digits.gram" # TODO: Please set your grammar
  # max_retry              2
  confirmation_method    :never

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
	      CreditCardIdentificationDialog
      end
    
    elsif rejected?(session, true)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        CreditCardIdentificationDialog
      end

    else # recognized
      if session[:result] != 'failure'
        # go to Flow I

        ##### CALL IDENTIFICATION API #####
        # result = get_identification session
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_ident")
        response = Net::HTTP.post_form(uri, "product" => session["result_item"]["product"], "card_id" => session["result"])
        session["identification_info"] = JSON.parse(response.body)
        if session["identification_info"]["product"] == session["result_item"]["product"] && session["identification_info"]["card_id"] == session["result"]
          session["card_id"] = session["result"]
          ConfirmCreditCardIdentificationDialog
        else
          AgentTransferBlock
        end
        # VerificationQuestionDialog
      else
        increase_retry(session)
        if (retry_exceeded? session) || (total_exceeded? session)
          AgentTransferBlock
        else
          CreditCardIdentificationDialog
        end
      end
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
