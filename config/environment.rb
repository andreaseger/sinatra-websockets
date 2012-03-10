require 'settings'
require 'bundler'

rack_env = ENV['RACK_ENV'] || 'development'

Bundler.setup
Bundler.require(:default, rack_env, :assets)
print "#{rack_env}\n"

REDIS_CONFIG =  if ENV['BRAIN_REDIS_URL'] && rack_env == 'production'
                  require 'uri'
                  uri = URI.parse ENV['BRAIN_REDIS_URL']
                  {
                    host: uri.host,
                    port: uri.port,
                    password: uri.password,
                    db: uri.path.gsub(/^\//, '')
                  }
                else
                  {}
                end
if MESSAGE_WRAPPER == :json
  require 'json'
  print "using JSON\n"
else
  require 'msgpack'
  print "using MessagePack\n"
end


require_relative '../lib/assets.rb'