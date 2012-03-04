require_relative 'lib/asset_helper'

class App < Sinatra::Base
  register Mustache::Sinatra
  register Sinatra::Namespace
  require_relative 'views/layout.rb'

  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  set :assets_prefix, 'assets'
  set :assets_path, File.join(public_folder, assets_prefix)

  set :sprockets, ::AssetHelper::sprockets
  configure do |c|
    set :mustache, {
      templates: File.join(root, 'templates'),
      views: File.join(root, 'views'),
      namespace: App
    }
    $redis = Redis.new(REDIS_CONFIG)
    puts "redis: #{REDIS_CONFIG}"
  end

  configure :development do |c|
    register Sinatra::Reloader
    c.also_reload "./lib/**/*.rb"
    c.also_reload "./views/**/*.tb"
  end

  get '/' do
    mustache :home
  end
end
