class SelfServiceCreditCardOutstandingBalanceDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         { |session| 
                  prompts = []
                  data = session["announcement_info"]["card_info"][0]
                  card_id = data["card_id"]
                  card_type = data["card_type"]
                  credit_limit = data["amount"]["credit_limit"].gsub(",", "")
                  statement_closing_date = data["statement_date"]
                  total_payment_due = data['amount']["usage_balance"]["usage"].gsub(",", "")
                  minimum_payment_due = data['min_payment'].gsub(",", "")
                  due_date = data['due_date']

                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][0] #"card_type"
                  prompts.push "#{card_type.downcase.gsub(" ", "_")}"
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][1] #"ending_card_id"
                  prompts.push card_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][2] #"close_date_card_balance"
                  prompts.push NamedPrompt.date_prompts(statement_closing_date, skip_full_year:false, skip_this_year:false)
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][3] #"payment_amount"
                  prompts.push NamedPrompt.currency_prompts total_payment_due
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][4] #"minimum_payment_amount"
                  prompts.push NamedPrompt.currency_prompts minimum_payment_due
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][5] #"due_date_card_balance"
                  prompts.push NamedPrompt.date_prompts(due_date, skip_full_year:false, skip_this_year:false)
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[0][6] #"you_can_listen_again"

                  prompts.flatten!
                  prompts
                }

  init2         { |session| 
                  prompts = []
                  data = session["announcement_info"]["card_info"][0]
                  card_id = data["card_id"]
                  card_type = data["card_type"]
                  credit_limit = data["amount"]["credit_limit"].gsub(",", "")
                  statement_closing_date = data["statement_date"]
                  total_payment_due = data['amount']["usage_balance"]["usage"].gsub(",", "")
                  minimum_payment_due = data['min_payment'].gsub(",", "")
                  due_date = data['due_date']

                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][0] #"card_type"
                  prompts.push "#{card_type.downcase.gsub(" ", "_")}"
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][1] #"ending_card_id"
                  prompts.push card_id.split('').last(4).map { |s| s.prepend('number/') }
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][2] #"close_date_card_balance"
                  prompts.push NamedPrompt.date_prompts(statement_closing_date, skip_full_year:false, skip_this_year:false)
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][3] #"payment_amount"
                  prompts.push NamedPrompt.currency_prompts total_payment_due
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][4] #"minimum_payment_amount"
                  prompts.push NamedPrompt.currency_prompts minimum_payment_due
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][5] #"due_date_card_balance"
                  prompts.push NamedPrompt.date_prompts(due_date, skip_full_year:false, skip_this_year:false)
                  prompts.push AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.prompts.init[1][6] #"you_can_listen_again"

                  prompts.flatten!
                  prompts
                }

  #
  #== Properties
  #
  grammar_name           AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.grammar_name #"yesno.gram" # TODO: Please set your grammar
  # max_retry              2
  confirmation_method    AmiVoice::DialogModule::Settings.dialog_property.self_service_credit_card_outstanding_balance_dialog.confirmation_option.parameterize.underscore.to_sym #:never

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
        SelfServiceCreditCardOutstandingBalanceDialog
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
