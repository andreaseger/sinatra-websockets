$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
$:.unshift File.expand_path("../.",__FILE__)
ROOT = File.dirname(__FILE__)

require 'goliath'
require 'websocket'

require 'environment'

require 'assets'
require 'assets_helper'
require 'template_helper'
#require 'goliath/rack/sprockets'

class AssetsAPI < Goliath::API
  include Goliath::Rack::AsyncMiddleware

  def post_process(env, status, headers, body)
    binding.pry
    ::Assets.sprockets.call({'PATH_INFO' => env['PATH_INFO'].gsub('/assets','')}) if env['PATH_INFO'] =~ /assets/
  end
end

class Foo < Goliath::API
  include Sinatra::TemplateHelper
  use AssetsAPI

  def response(env)
    p env['PATH_INFO']
    case env['PATH_INFO']
    when '/ws'
      WebSocket
    when /\/assets\/.*/
      super(env)
    when '/templates.json'
      [200, {}, templates ]
    else
      [200, {}, mustache(:home)] # manual render mustache template
    end
  end
end