require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
# Bundler.require(:development)
require 'mp3info'

require_relative 'src/downloader_option_parser'
require_relative 'src/music_providers/base'
require_relative 'src/music_providers/youtube'
require_relative 'src/music_providers/mail_ru'
require_relative 'src/downloader'
require_relative 'src/tags_verifier'
require_relative 'src/keys_fetcher'
require_relative 'src/color'

options = DownloaderOptionParser.new.parse

Yt.configure do |config|
  config.api_key = KeysFetcher.key(:youtube, :google_api_key)
end

downloader = Downloader.new(options[:music_provider], options[:path])

if options[:artist]
  downloader.dl_artist_top_tracks(options[:artist])
elsif options[:track]
  downloader.dl_track(options[:track])
elsif options[:spotify_playlist_url]
  RSpotify.authenticate(KeysFetcher.key(:spotify, :client_id), KeysFetcher.key(:spotify, :client_secret))
  downloader.dl_playlist_tracks(options[:spotify_playlist_url])
elsif options[:songs_file_path]
  downloader.dl_tracks_from_file(options[:songs_file_path])
end
