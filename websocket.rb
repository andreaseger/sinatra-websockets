$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
$:.unshift File.expand_path("../.",__FILE__)

require 'goliath'
require 'goliath/websocket'
require 'goliath/rack/templates'
require 'goliath/plugins/latency'

require 'environment'

require 'wrapper'
require 'assets'
require 'assets_helper'

require './views/layout'
root = File.dirname(__FILE__)
Mustache.template_path = File.join(root, 'templates')
Mustache.view_path = File.join(root, 'views')
Mustache.view_namespace = App::Views

class WebSocket < Goliath::WebSocket
  include ::Wrapper

  plugin Goliath::Plugin::Latency       # ask eventmachine reactor to track its latency

  def recent_latency
    Goliath::Plugin::Latency.recent_latency
  end

  @basetext = ''
  @diff2base = ''


  def onopen(env)
    env.logger.info("WS OPEN")
    env['subscription'] = env.channel.subscribe do |msg|
      env.stream_send p(msg)
    end

    unless @diff2base.empty?
      env.stream_send(p(  type: 'basetext', basetext: @basetext))
      env.stream_send(p(  type: 'update',   diff: @diff2base))
    end
  end

  def onclose(env)
    env.logger.info("WS CLOSED")
    env.channel.unsubscribe(env['subscription'])
  end

  def onmessage(env,msg)
    m = u msg
    env.logger.info("WS MESSAGE: #{m}")


    @diff2base = m['diff']
    if @diff2base.length > MAX_DIFF_LENGTH
      @basetext = env.dmp.patch_apply(env.dmp.patch_fromText(@diff2base), @basetext)[0]
      env.logger.info("UPDATE BASETEXT: #{@basetext}")
      message = { type: 'basetext', basetext: @basetext }
    else
      message = { type: 'update', diff: @diff2base }
    end
    env.channel << message
  end

  def onerror(env,error)
    env.logger.error error
  end

  def response(env)
    case env['REQUEST_PATH']
    when '/ws'
      super(env)
    when /\/assets\/.*/
      new_env = env.clone
      new_env["PATH_INFO"].gsub!('/assets','')
      ::Assets.sprockets.call(new_env)
    when '/templates.json'
      puts 'template'
    else
      [200, {}, Mustache.render(:home)] # manual render mustache template
    end
  end
end