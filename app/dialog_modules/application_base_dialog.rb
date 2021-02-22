#
# Default configuration and settings for all DialogModule
#
class ApplicationBaseDialog < SystemBaseDialog
  extend ::ApplicationHelper
  #
  # = Properities
  #
  fetch_audio                             ""
  fetch_timeout                           "30s"
  beep_filename                           "/prompts/beep.wav"
  play_beep_after_prompt                  true

  #
  # == Main State (dialog_state=='main')
  #
  grammar_name                            "builtin:grammar/-BKICallSteering"  #"builtin:grammar/-AmiDnnThaiTelephony8k_Bay_v8"
  dtmf_grammar                            ""
  max_retry                               1
  max_retry_noinput                       1
  max_retry_nomatch                       1
  max_retry_reject                        1
  max_retry_confirmation_no               1
  separate_retry_counter                  false
  confirmation_method                     :never
  high_confidence_threshold               0.9
  low_confidence_threshold                0.1
  bargein                                 false

  # === Speech Properties (VoiceXML)
  timeout                                 "5s"
  complete_timeout                        "0.8s"
  incomplete_timeout                      "1.0s"
  speed_vs_accuracy                       0.9
  max_speech_timeout                      "10s"
  confidence_level                        0.0
  # inter_digit_timeout                     "3s"
  # term_timeout                            "0s"
  # term_char                               "#"

  #
  # == Confirmation State (dialog_state='confirmation')
  #
  confirmation_grammar_name               "yesno.gram"
  confirmation_dtmf_grammar               ""
  confirmation_max_retry                  2
  confirmation_max_retry_noinput          2
  confirmation_max_retry_nomatch          2
  confirmation_separate_retry_counter     false
  confirmation_confidence_threshold       0.1
  confirmation_bargein                    false

  # === Speech Properties (VoiceXML)
  confirmation_timeout                    "5s"
  confirmation_complete_timeout           "0.3s"
  confirmation_incomplete_timeout         "0.8s"
  confirmation_speed_vs_accuracy          0.9
  confirmation_max_speech_timeout         "10s"
  confirmation_confidence_level           0.0
  # confirmation_inter_digit_timeout        "3s"
  # confirmation_term_timeout               "0s"
  # confirmation_term_char                  "#"

  error_in_vxml_occurred {|session, event, message|
    # If you want to take special action when a call gets exception, uncomment
    # below lines and describe system_error_block.vxml.erb accordingly.
    #
    #SystemErrorBlock
    nil
  }

  disconnected {|session, event, message|
    # If you want to take special action when a call is disconnected, uncomment
    # below lines and describe disconnected_block.vxml.erb accordingly.
    #
    #DisconnectedBlock
    nil
  }

  call_ending {|session, params|
  }
end
