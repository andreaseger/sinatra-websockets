@channel = EM::Channel.new

EventMachine::WebSocket.start(host: '0.0.0.0', port: 8080) do |ws|
  include ::Wrapper
  ws.onopen {
    sid = @channel.subscribe { |msg|
            ws.send p(msg)
          }
    @channel.push(sid: sid, msg: 'connected!')

    ws.onclose {
      @channel.unsubscribe(sid)
      @channel.push(sid: sid, msg: 'disconnected!')
    }

    ws.onmessage { |msg|
      m = u msg
      @channel.push(sid: sid, msg: m['msg'])
    }

    ws.onerror { |error|
      puts "Error occured: " + error.message
    }
  }
end