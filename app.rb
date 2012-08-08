require_relative 'lib/assets'
require_relative 'lib/assets_helper'
require_relative 'lib/template_helper'

class App < Sinatra::Base
  register Mustache::Sinatra
  register Sinatra::Namespace
  require_relative 'views/layout.rb'
  helpers Sinatra::TemplateHelper

  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')

  configure do |c|
    set :mustache, {
      templates: File.join(root, 'templates'),
      views: File.join(root, 'views'),
      namespace: App
    }
  end

  configure :development do |c|
    register Sinatra::Reloader
    c.also_reload "./lib/**/*.rb"
    c.also_reload "./views/**/*.tb"
  end

  get '/templates.json' do
    json templates
  end

  get '/assets/*' do
    new_env = env.clone
    new_env["PATH_INFO"].gsub!('/assets','')
    ::Assets.sprockets.call(new_env)
  end

  get '/' do
    mustache :home
  end
end