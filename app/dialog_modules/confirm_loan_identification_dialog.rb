class ConfirmLoanIdentificationDialog < ApplicationBaseDialog

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
  init1         { |session|
                  prompts = []
                  prompts.push @dialog_property["prompts"]["init"][0][0]
                  prompts.push '%speech_input_iden_number_prompts%'
                  prompts.push @dialog_property["prompts"]["init"][0][1]
                  prompts.flatten!
                  prompts
                }
                
  init2         { |session|
                  prompts = []
                  prompts.push @dialog_property["prompts"]["init"][1][0]
                  prompts.push '%speech_input_iden_number_prompts%'
                  prompts.push @dialog_property["prompts"]["init"][1][1]
                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           "yesno.gram"
  confirmation_method    get_confirmation_dialog(ConfirmLoanIdentificationDialog.name) # :never

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
	      LoanIdentificationDialog
      end
    
    elsif rejected?(session, true)
      increase_reject(session)
      if (reject_exceeded?(session)) || (total_exceeded?(session))
        AgentTransferBlock
      else
        LoanIdentificationDialog
      end

    else # recognized
      if session["result"] =~ /yes/i
        product = session["result_item"]["product"]
        intention = session["result_item"]["intention"].last
        iden_id = session["result_item"]["iden_id"]
        uri = URI.parse("http://172.24.1.40/amivoice_api/api/v1/get_ident")
        response = Net::HTTP.post_form(uri, "product" => product, "citizen_id" => iden_id)
        session["identification_info"] = JSON.parse(response.body)
        if session["identification_info"]["product"] == product && session["identification_info"]["citizen_id"] == iden_id
          if @intention_config["code_#{intention}"]["verification"]["pass_in"] == 0
            announce_self_service(session)
          else
            VerificationQuestionDialog
          end
        else
          increase_retry(session)
          if (retry_exceeded? session) || (total_exceeded? session)
            AgentTransferBlock
          else
            LoanIdentificationDialog
          end
        end
      else
        increase_retry(session)
        if (retry_exceeded? session) || (total_exceeded? session)
          AgentTransferBlock
        else
          LoanIdentificationDialog
        end
      end
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
