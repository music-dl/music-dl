require 'optparse'

class DownloaderOptionParser
  DEFAULT_PATH = 'audio'.freeze

  def initialize
    @options = {}
  end

  def parse
    parser.parse!
    validate!

    @options
  end

  private

  def validate!
    options_error =
      if @options.slice(:artist, :track, :spotify_playlist_url, :songs_file_path).values.length != 1
        "[#{Color.red('ERROR')}] One of --artist, --track, --spotify-playlist-url or --songs-file-path must be provided"
      end

    if options_error
      puts "missing argument: #{options_error}"
      puts
      puts parser.help
      puts
      raise OptionParser::MissingArgument.new(options_error)
    end
  end

  def parser
    @parser ||= OptionParser.new do |opts|
      opts.banner = 'Usage: ruby main.rb [options]'

      opts.on('-t', '--track TRACK', 'single track name for youtube search. Download this track') do |track|
        @options[:track] = track
      end

      opts.on('-a', '--artist ARTIST', "artist's name for spotify search. Download artist's top 10 tracks") do |artist|
        @options[:artist] = artist
      end

      opts.on('-p', '--spotify-playlist-url URL', 'url to spotify playlist. Download tracks of this playlist') do |url|
        @options[:spotify_playlist_url] = url
      end

      opts.on('-f', '--songs-file-path PATH',
              'path to file with track names each in new line. Download these tracks') do |file_path|
        @options[:songs_file_path] = file_path
      end

      @options[:music_provider] = MusicProviders::Youtube.new
      opts.on('-y', '--youtube', 'use YouTube to download tracks') do
        @options[:music_provider] = MusicProviders::Youtube.new
      end

      opts.on('-m', '--mailru', 'use mail.ru/music to download tracks') do
        @options[:music_provider] = MusicProviders::MailRu.new
      end

      @options[:path] = DEFAULT_PATH
      opts.on('-d', '--destination-path PATH',
              "destination of downloaded files (default ./#{DEFAULT_PATH})") do |path|
        @options[:path] = path
      end
    end
  end
end
