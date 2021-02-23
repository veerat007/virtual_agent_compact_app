class ThankYouBlock < AmiVoice::DialogModule::BlockBase
  
  class << self

    exit_after_this_block = true

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

    prompts = ["thank_you"]

    define_method :prompts= do |audio_filenames|
      prompts = audio_filenames
    end

    define_method :prompts do
      prompts
    end
  end
  #
  # Action
  #
  # action do |session, params|
  #   # TODO: Please describe action here and set appropriate next dialog or block.
  #   # Here is an example to recieve audio recorded by VoiceXML

  #   output_dir = '/tmp/uploads/'
  #   FileUtils.mkdir_p output_dir unless File.exist?(output_dir)
  #   filename = "#{Time.now.strftime('%Y%m%d')}_#{SecureRandom.hex(10)}.wav"
  #   output_filename = File.join(output_dir, filename)
  #   FileUtils.copy params["msg"][:tempfile].path, output_filename

  #   # TODO: The last value should be next dialog.  But note that this block does
  #   # not allow to use 'return'.
  #   ThankYouBlock
  # end
end
