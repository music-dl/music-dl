require 'yaml'

class KeysFetcher
  SECRETS_PATH = 'secrets.yml'.freeze

  class << self
    def key(*key_path)
      result = keys_hash
      key_path.each do |path_part|
        result = result[path_part]
        quit result.blank? do
          puts "[#{Color.red('ERROR')}] #{key_path.join(' ').humanize} is not provided. #{see_readme_msg}"
        end
      end
      result
    end

    private

    def keys_hash
      @keys_hash ||= begin
        quit !File.exist?(SECRETS_PATH) || !(yaml = YAML.load(File.read(SECRETS_PATH))) do
          puts "[#{Color.red('ERROR')}] Fill in #{SECRETS_PATH} file. #{see_readme_msg}"
        end
        yaml.with_indifferent_access
      end
    end

    def see_readme_msg
      'See README.md for more info'
    end

    def quit(condition)
      return unless condition
      yield if block_given?
      puts
      raise ArgumentError
    end
  end
end
