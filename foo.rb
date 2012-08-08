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
  include ::Assets

  def post_process(env, status, headers, body)
    p 'asd:w'
    self.sprockets.call(env)
  end
end

class App < Goliath::API
  include Goliath::TemplateHelper
  def response(env)
    p env['PATH_INFO']
    case env['PATH_INFO']
    when '/ws'
      WebSocket
    when /\/assets\/.*/
      new_env = env.clone
      new_env["PATH_INFO"].gsub!('/assets','')
      ::Assets.sprockets.call(new_env)
    when '/templates.json'
      [200, {}, templates ]
    else
      [200, {}, mustache(:home)] # manual render mustache template
    end
  end
end