# coding: utf-8
require_relative '../../test_helper'

class MainMenuDialogTest < Minitest::Test
  include AmiVoice::DialogModule::Utility

  def test_init_prompts
    session = create_session ({
       dialog_state: "main"
    })
    prompts = MainMenuDialog.session_prompts(session)
    # TODO: Set your expected prompts for the input
    expected = []
    assert_equal expected, prompts[:init1]
  end

  def test_next_dialog
    session = create_session ({
      result: "yes"
    # TODO: Set your expected next dialog
    })
    expected = nil
    assert_equal expected, MainMenuDialog.execute_action(session)
  end

end
