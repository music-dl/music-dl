module MusicProviders
  class Youtube < Base
    def download(track_name, path)
      videos = Yt::Collections::Videos.new
      video = videos.where(q: track_name, safe_search: 'none', order: 'relevance').first
      show_downloading_msg(track_name, "https://www.youtube.com/watch?v=#{video.id}")

      file_path = File.join(path, '%(title)s.%(ext)s')
      download_command = "youtube-dl --extract-audio --audio-format #{AUDIO_FORMAT} -o '#{file_path}' '#{video.id}'"
      downloaded_file_name = `#{download_command} --get-filename`.gsub(/\.\w+\n/, ".#{AUDIO_FORMAT}")
      `#{download_command}`

      show_saved_msg(track_name, downloaded_file_name)
    end
  end
end
