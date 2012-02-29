class App < Sinatra::Base
  register Mustache::Sinatra
  register Sinatra::Namespace
  require_relative 'views/layout.rb'

  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')

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

  before do
    @settings = settings
  end
  get '/' do
    mustache :home
  end
end