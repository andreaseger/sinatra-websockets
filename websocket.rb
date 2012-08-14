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

#    unless diff2base.empty?
#      env.stream_send(p(  type: 'basetext', basetext: basetext))
#      env.stream_send(p(  type: 'update',   diff: diff2base))
#    end
  end

  def on_close(env)
    env.logger.info("WS CLOSED")
    env.channel.unsubscribe(env['subscription'])
  end

  def on_message(env,msg)
    p "message #{msg}"
    m = u msg
    env.logger.info("WS MESSAGE: #{m}")
    pad = m['pad']

    case m['type']
    when 'update'
      diff = m['diff']
      redis.set(db_key(pad,'diff2base'), diff)

      if false#diff.length > MAX_DIFF_LENGTH
        # make some real text out of the last diffs
        new_base, success = dmp.patch_apply(dmp.patch_fromText(diff), basetext)
        if success
          basetext= new_base
          env.logger.info("UPDATE BASETEXT: #{new_base}")
          message = { type: 'basetext', basetext: new_base }
        end
      else
        message = { type: 'update', diff: diff }
      end
    when 'subscribe'
      #TODO use m['pad']
      env['subscription'] = env.channel.subscribe do |msg|
        env.stream_send p(msg)
      end
      redis.exists(db_key(pad,'diff2base')) do |response|
        if response
          redis.get(db_key(pad,'diff2base')) do |diff|
            env.stream_send(p(  type: 'update',   diff: diff))
          end
        end
      end
      env.stream_send p({ type: 'subscription', data: "subscribed to pad: #{pad}"})
    end

    env.channel << message if message
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
  def db_key(pad,key)
    "pad:#{pad}:#{key}"
  end
end