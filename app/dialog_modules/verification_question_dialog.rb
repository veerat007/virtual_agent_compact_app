class VerificationQuestionDialog < ApplicationBaseDialog


  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  before_generate_vxml {|session, params|
    @dialog_property = get_dialog_property(session)
    @intention_config = get_intention_list(session)
  }

  #
  #== Prompts
  #
  init1         ['%announce_verify_question%']
  init2         ['%announce_verify_question%']

  #
  #== Properties
  #
  # grammar_name           "birth_weekday.gram"
  confirmation_method    get_confirmation_dialog(VerificationQuestionDialog.name) #:never

  #
  #==Action
  #
  action do |session|
    # TODO: Please describe action here and set appropriate next dialog.
    # The last value should be next dialog.  But note that this block does not allow
    # to use 'return'.
    session.logger.info("action")

    session["pass_count"] = 0 if session["pass_count"].blank?
    session["max_count"]  = 0 if session["max_count"].blank?
    intention = session["result_item"]["intention"]

    if session["max_count"] <= @intention_config["code_#{intention}"]["verification"]["max_question"]
      session["max_count"] += 1
      if session["identification_info"]["birth_weekday"] == session["result"] || session["identification_info"]["date_of_birth"] == session["result"] || session["identification_info"]["phone_number"] == session["result"] # PRODUCT = "Credit Card"
        session["pass_count"] += 1
      end
      if session["pass_count"] == @intention_config["code_#{intention}"]["verification"]["pass_in"]
        if session["result_item"]["product"] == 'credit_card'
          ##### CALL CREDIT CARD ANNOUNCEMENT API #####
          uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
          response = Net::HTTP.post_form(uri, "product" => session["identification_info"]["product"], "card_id" => session["identification_info"]["card_id"])
          session["announcement_info"] = JSON.parse(response.body)
          if session["announcement_info"]["card_info"][0]["card_status"] == "active" #session["announcement_info"]["status"] != "error" && session["announcement_info"]["card_status"] == "active"
            if session["result_item"]["intention"] == "002" #"remaining_balance"
              SelfServiceCreditCardRemainingBalanceDialog
            elsif session["result_item"]["intention"] == "003" #"outstanding_balance"
              SelfServiceCreditCardOutstandingBalanceDialog
            elsif session["result_item"]["intention"] == "004" #"usage_balance"
              SelfServiceCreditCardUsageBalanceDialog
            else # session["result_item"]["intention"] == "001" # "enquire_balance"
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
            SelfServiceBankAccountBalanceDialog # session["result_item"]["intention"] == "001" || session["result_item"]["intention"] == "002"
          else
            AgentTransferBlock
          end
        else # PRODUCT = "Loan"
          AgentTransferBlock
        end
      else
        VerificationQuestionDialog
      end
    else
      AgentTransferBlock
    end


    if session["identification_info"]["birth_weekday"] == session["result"] || session["identification_info"]["date_of_birth"] == session["result"] || session["identification_info"]["phone_number"] == session["result"] # PRODUCT = "Credit Card"
      if session["result_item"]["product"] == 'credit_card'
        ##### CALL CREDIT CARD ANNOUNCEMENT API #####
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_data")
        response = Net::HTTP.post_form(uri, "product" => session["identification_info"]["product"], "card_id" => session["identification_info"]["card_id"])
        session["announcement_info"] = JSON.parse(response.body)
        if session["announcement_info"]["card_info"][0]["card_status"] == "active" #session["announcement_info"]["status"] != "error" && session["announcement_info"]["card_status"] == "active"
          if session["result_item"]["intention"] == "002" #"remaining_balance"
            SelfServiceCreditCardRemainingBalanceDialog
          elsif session["result_item"]["intention"] == "003" #"outstanding_balance"
            SelfServiceCreditCardOutstandingBalanceDialog
          elsif session["result_item"]["intention"] == "004" #"usage_balance"
            SelfServiceCreditCardUsageBalanceDialog
          else # session["result_item"]["intention"] == "001" # "enquire_balance"
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
          SelfServiceBankAccountBalanceDialog # session["result_item"]["intention"] == "001" || session["result_item"]["intention"] == "002"
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
