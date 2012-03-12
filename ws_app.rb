@channel = EM::Channel.new
@dmp = DiffMatchPatch.new
@basetext = ''
@diff2base = ''

EventMachine::WebSocket.start(host: '0.0.0.0', port: 8080) do |ws|
  include ::Wrapper
  ws.onopen {
    sid = @channel.subscribe { |msg|
            ws.send p(msg)
          }
    ws.send(p(type: 'basetext', basetext: @basetext)) unless @basetext.empty?
    ws.send(p(type: 'update', diff: @diff2base)) unless @diff2base.empty?

    ws.onclose {
      @channel.unsubscribe(sid)
    }

    ws.onmessage { |msg|
      m = u msg
      puts m
      @diff2base = m['diff']
      if @diff2base.length > MAX_DIFF_LENGTH
        @basetext = @dmp.patch_apply(@dmp.patch_fromText(@diff2base), @basetext)[0]
        @channel.push(type: 'basetext', basetext: @basetext)
        puts @basetext
      else
        @channel.push(sid: sid, type: 'update', diff: @diff2base)
      end
    }

    ws.onerror { |error|
      puts "Error occured: " + error.message
    }
  }
end