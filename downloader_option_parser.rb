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
        'One of --artist, --track or --spotify-playlist-url must be provided'
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

      opts.on('-t', '--track TRACK', 'download single track') do |track|
        @options[:track] = track
      end

      opts.on('-a', '--artist ARTIST', "download artist's top 10 tracks") do |artist|
        @options[:artist] = artist
      end

      opts.on('-p', '--spotify-playlist-url URL', 'url to spotify playlist') do |path|
        @options[:spotify_playlist_url] = path
      end

      opts.on('-f', '--songs-file-path URL', 'path to file with songs names each in new line') do |path|
        @options[:songs_file_path] = path
      end

      @options[:path] = DEFAULT_PATH
      opts.on('-d', '--destination-path PATH', "path for downloaded files (default ./#{DEFAULT_PATH})") do |path|
        @options[:path] = path
      end
    end
  end
end
