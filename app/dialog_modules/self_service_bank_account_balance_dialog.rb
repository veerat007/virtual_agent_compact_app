class SelfServiceBankAccountBalanceDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

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

                  prompts.push "ending_account_id"
                  prompts.push bank_account_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push "account_balance"
                  if '%.2f' % balance.to_f < '%.2f' % (0).to_f
                    prompts.push "negative_balance"
                    prompts.push NamedPrompt.currency_prompts balance
                  else
                    prompts.push "amount_backing"
                    prompts.push NamedPrompt.currency_prompts balance
                  end
                  
                  if '%.2f' % withdrawable_amount.to_f < '%.2f' % (0).to_f
                    prompts.push "withdrawable_negative_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  else
                    prompts.push "withdrawable_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  end

                  prompts.push "interest_received_until_end_date"
                  prompts.push NamedPrompt.date_prompts(interest_due_date, skip_full_year:false, skip_this_year:false)
                  prompts.push "interest_payment"
                  prompts.push NamedPrompt.currency_prompts interest_amount
                  prompts.push "you_can_listen_again"

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

                  prompts.push "ending_account_id"
                  prompts.push bank_account_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push "account_balance"
                  if '%.2f' % balance.to_f < '%.2f' % (0).to_f
                    prompts.push "negative_balance"
                    prompts.push NamedPrompt.currency_prompts balance
                  else
                    prompts.push "amount_backing"
                    prompts.push NamedPrompt.currency_prompts balance
                  end
                  
                  if '%.2f' % withdrawable_amount.to_f < '%.2f' % (0).to_f
                    prompts.push "withdrawable_negative_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  else
                    prompts.push "withdrawable_amount"
                    prompts.push NamedPrompt.currency_prompts withdrawable_amount
                  end

                  prompts.push "interest_received_until_end_date"
                  prompts.push NamedPrompt.date_prompts(interest_due_date, skip_full_year:false, skip_this_year:false)
                  prompts.push "interest_payment"
                  prompts.push NamedPrompt.currency_prompts interest_amount
                  prompts.push "you_can_listen_again"

                  prompts.flatten!
                  prompts
                }

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
  grammar_name           "yesno.gram" # TODO: Please set your grammar
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
      AskForMoreServiceDialog
    
    elsif rejected?(session, true)
      increase_reject(session)
      AskForMoreServiceDialog

    else # recognized
      if session["result"] =~ /yes/i
        SelfServiceBankAccountBalanceDialog
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
