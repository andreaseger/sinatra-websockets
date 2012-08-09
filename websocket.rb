$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
$:.unshift File.expand_path("../.",__FILE__)

require 'environment'
require 'wrapper'

require 'goliath'
require 'goliath/plugins/latency'
require 'goliath/websocket'

class Websocket < Goliath::WebSocket
  plugin Goliath::Plugin::Latency       # ask eventmachine reactor to track its latency
  include ::Wrapper

  def recent_latency
    Goliath::Plugin::Latency.recent_latency
  end

  def on_open(env)
    env.logger.info("WS OPEN")
    env['subscription'] = env.channel.subscribe do |msg|
      env.stream_send p(msg)
    end

    unless diff2base.empty?
      env.stream_send(p(  type: 'basetext', basetext: basetext))
      env.stream_send(p(  type: 'update',   diff: diff2base))
    end
  end

  def on_close(env)
    env.logger.info("WS CLOSED")
    env.channel.unsubscribe(env['subscription'])
  end

  def on_message(env,msg)
    p "message #{msg}"
    m = u msg
    env.logger.info("WS MESSAGE: #{m}")


    diff2base = m['diff']
    if diff2base.length > MAX_DIFF_LENGTH
      basetext = env.dmp.patch_apply(env.dmp.patch_fromText(diff2base), basetext)[0]
      env.logger.info("UPDATE BASETEXT: #{basetext}")
      message = { type: 'basetext', basetext: basetext }
    else
      message = { type: 'update', diff: diff2base }
    end
    env.channel << message
  end

  def on_error(env,error)
    env.logger.error error
  end

  def response(env)
    env.logger.info env['REQUEST_PATH']
    if env['REQUEST_PATH'] == '/ws'
      super(env)
    end
  end

private
  def basetext
    return '' unless env.redis.exists "123:basetext"
    env.redis.get "123:basetext"
  end

  def basetext= text
    env.redis.set "123:basetext", text
  end

  def diff2base
    return '' unless env.redis.exists "123:diff2base"
    env.redis.get "123:diff2base"
  end

  def diff2base= diff
    env.redis.set "123:diff2base", diff
  end

end