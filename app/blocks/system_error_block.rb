#
#
#
class SystemErrorBlock < AmiVoice::DialogModule::BlockBase

  class << self

    exit_after_this_block = false

    define_method :exit= do |value|
      exit_after_this_block = value
    end

    define_method :exit? do
      exit_after_this_block
    end

    namelist = {}

    define_method :namelist= do |value|
      namelist = value
    end

    define_method :namelist do
      namelist
    end

    prompts = ["service_unavailable"]

    define_method :prompts= do |audio_filenames|
      prompts = audio_filenames
    end

    define_method :prompts do
      prompts
    end
  end
end
