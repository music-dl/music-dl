require 'shellwords'

class Downloader
  THREADS_NUMBER = 3
  AUDIO_FORMAT = 'mp3'.freeze

  def initialize(path)
    @path = path
  end

  def dl_artist_top_tracks(artist_name)
    artist = RSpotify::Artist.search(artist_name).first
    dl_tracks(names_from_tracks(artist.top_tracks(:US)), directory: artist.name)
  end

  def dl_playlist_tracks(playlist_url)
    playlist = RSpotify::Playlist.find(*parse_playlist_url(playlist_url))
    dl_tracks(names_from_tracks(playlist.tracks), directory: playlist.name)
  end

  def dl_tracks_from_file(file_path)
    tracks_names = File.read(file_path).split("\n")
    dl_tracks(tracks_names, directory: File.basename(file_path, '.*'))
  end

  def dl_track(track_name, directory: nil)
    videos = Yt::Collections::Videos.new
    video = videos.where(q: track_name, safe_search: 'none', order: 'relevance').first

    puts "#{Color.pink('Downloading')} #{Color.blue(track_name)} from https://www.youtube.com/watch?v=#{video.id}"
    file_path = File.join([@path, directory, '%(title)s.%(ext)s'].compact)
    download_command = "youtube-dl --extract-audio --audio-format #{AUDIO_FORMAT} -o '#{file_path}' '#{video.id}'"
    downloaded_file_name = `#{download_command} --get-filename`.gsub(/\.\w+\n/, ".#{AUDIO_FORMAT}")
    `#{download_command}`

    puts "#{Color.green('Saved')} #{Color.blue(track_name)} in\n"\
         "#{Color.light_blue(Shellwords.escape(downloaded_file_name))}"
    puts
  end

  private

  def dl_tracks(tracks_names, directory: nil)
    tracks_names.in_groups(THREADS_NUMBER, false).map do |tracks_names_chunk|
      Thread.new do
        tracks_names_chunk.each do |track_name|
          dl_track(track_name, directory: directory)
        end
      end
    end.each(&:join)
  end

  # https://play.spotify.com/user/1249251980/playlist/3SC5B4DyGykKQIcNA7uemX
  #
  def parse_playlist_url(url)
    rest_parts = URI.parse(url).path.split('/')
    user_id = rest_parts.split('user').last.first
    playlist_id = rest_parts.split('playlist').last.first
    [user_id, playlist_id]
  end

  def names_from_tracks(tracks)
    tracks.map { |t| "#{t.artists.first.name} - #{t.name}" }
  end
end
