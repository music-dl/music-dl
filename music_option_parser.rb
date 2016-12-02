class MusicOptionParser
  DEFAULT_PATH = 'audio'.freeze

  def initialize
    @options = { path: DEFAULT_PATH }
  end

  def parse
    parser.parse!
    validate

    @options
  end

  private

  def validate
    options_error =
      if @options[:youtube_api_key].nil?
        '--youtube-api-key must be provided'
      elsif @options[:artist].nil? && @options[:track].nil?
        '--artist or --track option must be provided'
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

      opts.on('-s', '--skip-gems-installation') do
        @options[:skip_gems_installation] = true
      end

      opts.on('-t', '--track TRACK', 'download single track') do |track|
        @options[:track] = track
      end

      opts.on('-a', '--artist ARTIST', "download artist's top 10 spotify tracks") do |artist|
        @options[:artist] = artist
      end

      opts.on('-k', '--youtube-api-key KEY',
              'youtube api key. It can be created here https://console.developers.google.com/') do |youtube_api_key|
        @options[:youtube_api_key] = youtube_api_key
      end

      opts.on('-p', '--path PATH', "path for downloading (default ./#{DEFAULT_PATH})") do |path|
        @options[:path] = path
      end
    end
  end
end
