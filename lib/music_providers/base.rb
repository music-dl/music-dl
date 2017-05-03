module MusicProviders
  class Base
    AUDIO_FORMAT = 'mp3'.freeze

    def download(track_name, path)
      raise NotImplementedError
    end

    protected

    def show_downloading_msg(track_name, url)
      puts "#{Color.pink('Downloading')} #{Color.blue(track_name)} from #{url}"
    end

    def show_saved_msg(track_name, downloaded_file_name)
      puts "#{Color.green('Saved')} #{Color.blue(track_name)} in "\
           "#{Color.light_blue(Shellwords.escape(downloaded_file_name))}"
    end
  end
end
