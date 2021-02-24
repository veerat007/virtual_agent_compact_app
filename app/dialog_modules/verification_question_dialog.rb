class VerificationQuestionDialog < ApplicationBaseDialog


  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['%announce_verify_question%']
  init2         ['%announce_verify_question%']

  # retry1        ['sorry_i_cannot_understand_you',
  #                'can_you_say_yes_or_no_again']
  # retry2        ['sorry_i_cannot_understand_you_again',
  #                'can_you_say_again']

  # timeout1      ['sorry_i_cannot_hear_you',
  #                'can_you_say_yes_or_no_again']
  # timeout2      ['sorry_i_cannot_hear_you_again',
  #                'can_you_say_again']

  # reject1       ['can_you_say_yes_or_no_again']
  # reject2       ['can_you_say_again']

  # confirmation_init1    ['%speech_input_number_prompts%', 'is_it_correct']
  # confirmation_retry1   ['sorry_i_cannot_understand_you',
  #                        '%speech_input_number_prompts%',
  #                        'is_it_right']
  # confirmation_timeout1 ['sorry_i_cannot_hear_you',
  #                        '%speech_input_number_prompts%',
  #                        'is_it_right']

  #
  #== Properties
  #
  grammar_name          "birth_weekday.gram"
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



    if session["identification_info"]["birth_weekday"] == session["result"] # PRODUCT = "Credit Card"
      if session["result_item"]["product"] == 'credit_card'
        ##### CALL CREDIT CARD ANNOUNCEMENT API #####
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
        response = Net::HTTP.post_form(uri, "product" => session["identification_info"]["product"], "card_id" => session["identification_info"]["card_id"])
        session["announcement_info"] = JSON.parse(response.body)
        if session["announcement_info"]["card_info"][0]["card_status"] == "active" #session["announcement_info"]["status"] != "error" && session["announcement_info"]["card_status"] == "active"
          if session["result_item"]["intention"] == "remaining_balance"
            SelfServiceCreditCardRemainingBalanceDialog
          elsif session["result_item"]["intention"] == "outstanding_balance"
            SelfServiceCreditCardOutstandingBalanceDialog
          elsif session["result_item"]["intention"] == "usage_balance"
            SelfServiceCreditCardUsageBalanceDialog
          else
            SelfServiceCreditCardBalanceDialog
          end
        else
          AgentTransferBlock
        end

      elsif session["result_item"]["product"] == 'bank_account' # PRODUCT = "Bank Account"
        ##### CALL BANK ACCOUNT ANNOUNCEMENT API #####   
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
        response = Net::HTTP.post_form(uri, "product" => session["identification_info"]["product"], "account_no" => session["identification_info"]["bank_account_id"])
        session["announcement_info"] = JSON.parse(response.body)
        if session["announcement_info"]["account_info"][0]["account_status"] == "active"
          SelfServiceBankAccountBalanceDialog
        else
          AgentTransferBlock
        end
      else # PRODUCT = "Loan"
        AgentTransferBlock
      end
    else
      AgentTransferBlock
      # VerificationQuestionDialog
    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
