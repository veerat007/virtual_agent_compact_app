class MainMenuDialog < ApplicationBaseDialog

  description <<-"DESCRIPTION"
    TODO: Explain this dialog module briefly
  DESCRIPTION

  #
  #== Prompts
  #
  init1         ['welcome',
                 'please_say_yes_or_no']
  init2         ['please_say_yes_or_no']

  retry1        ['sorry_i_cannot_understand_you',
                 'can_you_say_yes_or_no_again']
  retry2        ['sorry_i_cannot_understand_you_again',
                 'can_you_say_again']

  timeout1      ['sorry_i_cannot_hear_you',
                 'can_you_say_yes_or_no_again']
  timeout2      ['sorry_i_cannot_hear_you_again',
                 'can_you_say_again']

  reject1       ['can_you_say_yes_or_no_again']
  reject2       ['can_you_say_again']

  confirmation_init1    ['%speech_input_prompts%', 'is_it_correct']
  confirmation_retry1   ['sorry_i_cannot_understand_you',
                         '%speech_input_prompts%',
                         'is_it_right']
  confirmation_timeout1 ['sorry_i_cannot_hear_you',
                         '%speech_input_prompts%',
                         'is_it_right']

  #
  #== Properties
  #
  #grammar_name           "yesno.gram" # TODO: Please set your grammar
  max_retry              2
  timeout                "3s"
  complete_timeout       "0.8s"
  incomplete_timeout     "1.0s"
  speed_vs_accuracy      0.9
  max_speech_timeout     "10s"
  confidence_level       0.0
  confirmation_method    :always
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
    if session[:result] != "failure" && session[:result].present?
      if contrain_intention ### Check contrains Intention.
        if count_intention < 1
          if has_product || intention_belong_to
            ### go to Flow C
          else
            if check_confirmation_never
              ### go to Flow D
            else
              ### go to Flow E
            end
          end
        else
          ### tranfer to agent
        end
      elsif contrain_product ### Check contrains Product.
        ### increse retry value
        MainMenuDialog
      else
        ### increase reject
        MainMenuDialog
      end
    else
      MainMenuDialog
    end
  end

#  ending do |session, params|
#    session.logger.info("ending")
#  end
end
