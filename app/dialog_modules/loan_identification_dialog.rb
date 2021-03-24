class LoanIdentificationDialog < ApplicationBaseDialog

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
  # grammar_name           "13digits.gram"
  confirmation_method    get_confirmation_dialog(LoanIdentificationDialog.name) #:never

  #
  #==Action
  #
  action do |session|
    # TODO: Please describe action here and set appropriate next dialog.
    # The last value should be next dialog.  But note that this block does not allow
    # to use 'return'.
    session.logger.info("action")
    # LoanIdentificationDialog
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
      iden_id = session["nl_result"]["nlu"]['keyword_extraction']["iden_id"]
      if iden_id.present? #session[:result] != 'failure'
        save_result(session)
        ConfirmLoanIdentificationDialog
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
