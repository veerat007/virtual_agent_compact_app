class BankAccountIdentificationDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  before_generate_vxml {|session, params|
    @dialog_property = get_dialog_property(session)
  }

  #
  #== Prompts
  #
  init1         { |session|
                  prompts = []
                  if @dialog_property.present?
                    prompts.push @dialog_property["prompts"]["init"][0]
                  end
                  prompts.flatten!
                  prompts
                }
  init2         { |session|
                  prompts = []
                  if @dialog_property.present?
                    prompts.push @dialog_property["prompts"]["init"][1]
                  end
                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           "10digits.gram"
  confirmation_method    get_confirmation_dialog(BankAccountIdentificationDialog.name) #:never

  #
  #==Action
  #
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
