class SelfServiceCreditCardUsageBalanceDialog < ApplicationBaseDialog

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
                  data = session["announcement_info"]["card_info"][0]
                  card_id = data["card_id"]
                  card_type = data["card_type"]
                  credit_limit = data["amount"]["credit_limit"].gsub(",", "")
                  usage_balance = data['amount']["usage_balance"]["usage"].gsub(",", "")
                  over_usage_balance = data['amount']["usage_balance"]["over_usage"].gsub(",", "") if data['amount']["usage_balance"]["over_usage"].present?

                  prompts.push @dialog_property["prompts"]["init"][0][0] #"card_type"
                  prompts.push "#{card_type.downcase.gsub(" ", "_")}"
                  prompts.push @dialog_property["prompts"]["init"][0][1] #"ending_card_id"
                  prompts.push card_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push @dialog_property["prompts"]["init"][0][2] #"usage_balance"
                  prompts.push NamedPrompt.currency_prompts usage_balance
                  if data['amount']["usage_balance"]["over_usage"].present?
                    prompts.push @dialog_property["prompts"]["init"][0][3] #"over_usage_balance"
                    prompts.push NamedPrompt.currency_prompts over_usage_balance
                  end
                  prompts.push @dialog_property["prompts"]["init"][0][4] #"you_can_listen_again"

                  prompts.flatten!
                  prompts
                }
                
  init2         { |session| 
                  prompts = []
                  data = session["announcement_info"]["card_info"][0]
                  card_id = data["card_id"]
                  card_type = data["card_type"]
                  credit_limit = data["amount"]["credit_limit"].gsub(",", "")
                  usage_balance = data['amount']["usage_balance"]["usage"].gsub(",", "")
                  over_usage_balance = data['amount']["usage_balance"]["over_usage"].gsub(",", "") if data['amount']["usage_balance"]["over_usage"].present?

                  prompts.push @dialog_property["prompts"]["init"][1][0] #"card_type"
                  prompts.push "#{card_type.downcase.gsub(" ", "_")}"
                  prompts.push @dialog_property["prompts"]["init"][1][1] #"ending_card_id"
                  prompts.push card_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push @dialog_property["prompts"]["init"][1][2] #"usage_balance"
                  prompts.push NamedPrompt.currency_prompts usage_balance
                  if data['amount']["usage_balance"]["over_usage"].present?
                    prompts.push @dialog_property["prompts"]["init"][1][3] #"over_usage_balance"
                    prompts.push NamedPrompt.currency_prompts over_usage_balance
                  end
                  prompts.push @dialog_property["prompts"]["init"][1][4] #"you_can_listen_again"

                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           "yesno.gram"
  confirmation_method    get_confirmation_dialog(SelfServiceCreditCardUsageBalanceDialog.name) #:never

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
        if (retry_exceeded? session) || (total_exceeded? session)
          AskForMoreServiceDialog
        else
          SelfServiceCreditCardUsageBalanceDialog
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
