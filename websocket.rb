require 'goliath/websocket'
require 'wrapper'

class WebSocket < Goliath::WebSocket
  include ::Wrapper

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
end


