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
  # init2         ['%announce_verify_question%']

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
    product = session["result_item"]["product"]
    intention = session["result_item"]["intention"].last
    result = session["nl_result"]["nlu"]["keyword_extraction"]["verify"]
    
    if session["max_count"] <= @intention_config["code_#{intention}"]["verification"]["max_question"]
      session["max_count"] += 1
      if product == "credit_card"
        if session["identification_info"]["birth_weekday"].downcase == result || session["identification_info"]["date_of_birth"] == result || session["identification_info"]["phone_number"] == result
          session["pass_count"] += 1
        end
      elsif product == "bank_account"
        if session["identification_info"]["birth_weekday"].downcase == result || session["identification_info"]["date_of_birth"] == result || session["identification_info"]["phone_number"] == result || session["identification_info"]["have_atm_card"].downcase == result
          session["pass_count"] += 1
        end
      else #product == "loan"
        if session["identification_info"]["birth_weekday"].downcase == result || session["identification_info"]["date_of_birth"] == result || session["identification_info"]["phone_number"] == result
          session["pass_count"] += 1
        end
      end
      if session["pass_count"] == @intention_config["code_#{intention}"]["verification"]["pass_in"]
        announce_self_service(session)
      else
        if session["max_count"] >= @intention_config["code_#{intention}"]["verification"]["max_question"]
          AgentTransferBlock
        else
          VerificationQuestionDialog
        end
      end
    else
      AgentTransferBlock
    end

  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
