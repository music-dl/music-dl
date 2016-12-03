require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
# Bundler.require(:development)

require_relative 'downloader_option_parser'
require_relative 'downloader'
require_relative 'keys_manager'

options = DownloaderOptionParser.new.parse

Yt.configure do |config|
  config.api_key = KeysManager.key(:youtube, :google_api_key)
end

downloader = Downloader.new(options[:path])

if options[:artist]
  downloader.dl_artist_top_tracks(options[:artist])
elsif options[:track]
  downloader.dl_track(options[:track])
elsif options[:spotify_playlist_url]
  RSpotify.authenticate(KeysManager.key(:spotify, :client_id), KeysManager.key(:spotify, :client_secret))
  downloader.dl_playlist_tracks(options[:spotify_playlist_url])
elsif options[:songs_file_path]
  downloader.dl_tracks_from_file(options[:songs_file_path])
end
