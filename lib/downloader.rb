require 'shellwords'

class Downloader
  THREADS_NUMBER = 3

  def initialize(music_provider, path)
    @music_provider = music_provider
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
    @music_provider.download(track_name, File.join([@path, directory].compact))
  rescue => e
    puts "Error downloading track '#{track_name}' with #{@music_provider}: #{e.message}"
    puts e.backtrace.join("\n")
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
