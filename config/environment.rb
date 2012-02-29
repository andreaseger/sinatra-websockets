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


def sprockets
  return @sprockets if @sprockets
  compass_gem_root = Gem.loaded_specs['compass'].full_gem_path
  @sprockets = Sprockets::Environment.new { |env| env.logger = Logger.new(STDOUT) }
  @sprockets.append_path File.join 'assets', 'javascripts'
  @sprockets.append_path File.join 'assets', 'stylesheets'
  @sprockets.append_path File.join 'assets', 'images'
  @sprockets.append_path File.join Gem.loaded_specs['compass'].full_gem_path, 'frameworks', 'compass', 'stylesheets'
  @sprockets.append_path File.join Gem.loaded_specs['compass'].full_gem_path, 'frameworks', 'compass', 'stylesheets', 'compass'
  @sprockets.append_path File.join Gem.loaded_specs['compass-susy-plugin'].full_gem_path, 'sass'
  @sprockets
end
