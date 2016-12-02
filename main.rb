THREADS_NUMBER = 3
AUDIO_FORMAT = 'mp3'.freeze

require 'bundler/inline'
require 'optparse'
require_relative 'music_option_parser'

options = MusicOptionParser.new.parse

gemfile(!options[:skip_gems_installation]) do
  source 'https://rubygems.org'
  gem 'yt'
  gem 'rspotify'
  gem 'activesupport'
  # gem 'pry'
end

Yt.configure do |config|
  config.api_key = options[:youtube_api_key]
end

def download_track(track_name, path)
  videos = Yt::Collections::Videos.new
  video = videos.where(q: track_name, safe_search: 'none', order: 'relevance').first

  puts "Downloading '#{track_name}' from https://www.youtube.com/watch?v=#{video.id}"
  file_path = File.join(path, '%(title)s.%(ext)s')
  command_for_downloading = "youtube-dl --extract-audio --audio-format #{AUDIO_FORMAT} -o '#{file_path}' '#{video.id}'"
  downloaded_file_name = `#{command_for_downloading} --get-filename`.gsub(/\.\w+\n/, ".#{AUDIO_FORMAT}")
  `#{command_for_downloading}`

  puts "'#{track_name}' was saved in '#{downloaded_file_name}'"
end

def download_artist_top_tracks(artist_name, path)
  artist = RSpotify::Artist.search(artist_name).first
  artist.top_tracks(:US).in_groups(THREADS_NUMBER, false).map do |tracks_chunk|
    Thread.new do
      tracks_chunk.each do |track|
        track_name = "#{artist.name} - #{track.name}"
        download_track(track_name, File.join(path, artist.name))
      end
    end
  end.each(&:join)
end

if options[:artist]
  download_artist_top_tracks(options[:artist], options[:path])
elsif options[:track]
  download_track(options[:track], options[:path])
else
  puts options_parser.help
end
