class SelfServiceCreditCardRemainingBalanceDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         { |session| 
    prompts = []
    # result = get_identification session
    # session["announcement_info"].each { |announcement_info|
      data = session["announcement_info"]['card_info'][0]
      card_id = data['card_id']
      card_type = data['card_type']
      credit_limit = data['amount']['credit_limit']
      remaining_balance = data['amount']['remaining_balance']
      # date_closed = data['card_info']['dateClosed']
      # due_date = data['card_info']['dateDue']

      prompts.push 'credit_card_type/card'
      prompts.push "credit_card_type/#{card_type}"
      prompts.push "common/end_with"
      prompts.push card_id.split('').last(4).map { |s| s.prepend('number/') }
      prompts.push "self_service/credit_card/due_amount"
      prompts.push NamedPrompt.currency_prompts data['card_info']['dueAmount']
      prompts.push "self_service/credit_card/due_min_amount"
      prompts.push NamedPrompt.currency_prompts data['card_info']['dueMinAmount']
      prompts.push "self_service/credit_card/due_date"
      prompts.push NamedPrompt.date_prompts(due_date, skip_full_year:false, skip_this_year:false)
    }
  # }

  # init2         ['please_say_yes_or_no']

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

  # confirmation_init1    ['%speech_input_prompts%', 'is_it_correct']
  # confirmation_retry1   ['sorry_i_cannot_understand_you',
  #                        '%speech_input_prompts%',
  #                        'is_it_right']
  # confirmation_timeout1 ['sorry_i_cannot_hear_you',
  #                        '%speech_input_prompts%',
  #                        'is_it_right']

  #
  #== Properties
  #
  grammar_name           "yesno.gram" # TODO: Please set your grammar
  # max_retry              2
  # confirmation_method    :always

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
    SelfServiceCreditCardRemainingBalanceDialog
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
