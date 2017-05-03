require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'lib/keys_fetcher'

RSpotify.authenticate(KeysFetcher.key(:spotify, :client_id), KeysFetcher.key(:spotify, :client_secret))

require 'pry'
binding.pry
File.read('set_list.txt').split("\n").each do |song|

end
