require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
# Bundler.require(:development)

require_relative 'lib/downloader_option_parser'
require_relative 'lib/downloader'
require_relative 'lib/keys_fetcher'
require_relative 'lib/color'

options = DownloaderOptionParser.new.parse

Yt.configure do |config|
  config.api_key = KeysFetcher.key(:youtube, :google_api_key)
end

downloader = Downloader.new(options[:path])

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
