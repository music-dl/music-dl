require 'open-uri'

module MusicProviders
  class MailRu < Base
    def download(track_name, path)
      search_page_url = "https://my.mail.ru/music/search/#{URI.escape(track_name)}"
      show_downloading_msg(track_name, search_page_url)

      track_info = JSON.parse(RestClient.get(search_page_url).scan(/\{"file"\:.*?}/).first)
      track_url = track_info['url'].gsub(/\A\/\//, 'http://')
      file_name = "#{track_info['author']} - #{track_info['name']}.#{AUDIO_FORMAT}"
      file_path = File.join(path, file_name)

      save_tmp_file(open(track_url), file_path)

      show_saved_msg(track_name, file_path)
      file_path
    end

    private

    def save_tmp_file(file, path)
      dirname = File.dirname(path)
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

      FileUtils.cp(file.path, path)
    end
  end
end
