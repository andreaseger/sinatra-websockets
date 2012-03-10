@channel = EM::Channel.new

def pack(msg)
  if MESSAGEPACK
    msg.to_msgpack
  else
    msg.to_json
  end
end

def unpack(msg)
  if MESSAGEPACK
    MessagePack.unpack(msg)
  else
    JSON.parse(msg)
  end
end
alias :p :pack
alias :u :unpack

EventMachine::WebSocket.start(host: '0.0.0.0', port: 3000) do |ws|
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
  #EventMachine.add_periodic_timer(5) {
  #  @channel.push(sid: -1, msg: "--still alive---")
  #}
end