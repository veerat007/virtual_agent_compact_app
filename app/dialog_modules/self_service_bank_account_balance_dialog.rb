class SelfServiceBankAccountBalanceDialog < ApplicationBaseDialog

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
                  data = session["announcement_info"]["account_info"][0]
                  bank_account_id = data["bank_account_id"]
                  account_type = data["account_type"]
                  balance = data['amount']["balance"].gsub(",", "")
                  interest_amount = data['amount']["interest"].gsub(",", "")
                  withdrawable_amount = data['amount']["withdrawable_amount"].gsub(",", "")
                  interest_due_date = data['date']

                  prompts.push @dialog_property["prompts"]["init"][0][0] #"ending_account_id"
                  prompts.push bank_account_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push @dialog_property["prompts"]["init"][0][1] #"account_balance"
                  if '%.2f' % balance.to_f < '%.2f' % (0).to_f
                    prompts.push @dialog_property["prompts"]["init"][0][2] #"negative_balance"
                    prompts.push NamedPrompt.currency_prompts balance
                  else
                    prompts.push @dialog_property["prompts"]["init"][0][3] #"amount_backing"
                    prompts.push NamedPrompt.currency_prompts balance
                  end
                  
                  if '%.2f' % withdrawable_amount.to_f < '%.2f' % (0).to_f
                    prompts.push @dialog_property["prompts"]["init"][0][4] #"withdrawable_negative_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  else
                    prompts.push @dialog_property["prompts"]["init"][0][5] #"withdrawable_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  end

                  prompts.push @dialog_property["prompts"]["init"][0][6] #"interest_received_until_end_date"
                  prompts.push NamedPrompt.date_prompts(interest_due_date, skip_full_year:false, skip_this_year:false)
                  prompts.push @dialog_property["prompts"]["init"][0][7] #"interest_payment"
                  prompts.push NamedPrompt.currency_prompts interest_amount
                  prompts.push @dialog_property["prompts"]["init"][0][8] #"you_can_listen_again"

                  prompts.flatten!
                  prompts
                }

  init2         { |session| 
                  prompts = []
                  data = session["announcement_info"]["account_info"][0]
                  bank_account_id = data["bank_account_id"]
                  account_type = data["account_type"]
                  balance = data['amount']["balance"].gsub(",", "")
                  interest_amount = data['amount']["interest"].gsub(",", "")
                  withdrawable_amount = data['amount']["withdrawable_amount"].gsub(",", "")
                  interest_due_date = data['date']

                  prompts.push @dialog_property["prompts"]["init"][1][0] #"ending_account_id"
                  prompts.push bank_account_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push @dialog_property["prompts"]["init"][1][1] #"account_balance"
                  if '%.2f' % balance.to_f < '%.2f' % (0).to_f
                    prompts.push @dialog_property["prompts"]["init"][1][2] #"negative_balance"
                    prompts.push NamedPrompt.currency_prompts balance
                  else
                    prompts.push @dialog_property["prompts"]["init"][1][3] #"amount_backing"
                    prompts.push NamedPrompt.currency_prompts balance
                  end
                  
                  if '%.2f' % withdrawable_amount.to_f < '%.2f' % (0).to_f
                    prompts.push @dialog_property["prompts"]["init"][1][4] #"withdrawable_negative_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  else
                    prompts.push @dialog_property["prompts"]["init"][1][5] #"withdrawable_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  end

                  prompts.push @dialog_property["prompts"]["init"][1][6] #"interest_received_until_end_date"
                  prompts.push NamedPrompt.date_prompts(interest_due_date, skip_full_year:false, skip_this_year:false)
                  prompts.push @dialog_property["prompts"]["init"][1][7] #"interest_payment"
                  prompts.push NamedPrompt.currency_prompts interest_amount
                  prompts.push @dialog_property["prompts"]["init"][1][8] #"you_can_listen_again"

                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           "yesno.gram"
  confirmation_method    get_confirmation_dialog(SelfServiceBankAccountBalanceDialog.name) #:never

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
      AskForMoreServiceDialog
    
    elsif rejected?(session, true)
      increase_reject(session)
      AskForMoreServiceDialog

    else # recognized
      if session["result"] =~ /yes/i
        increase_retry(session)
        if (retry_exceeded? session) || (total_exceeded? session)
          AskForMoreServiceDialog
        else
          SelfServiceBankAccountBalanceDialog
        end
      else
        increase_retry(session)
        AskForMoreServiceDialog
      end
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
