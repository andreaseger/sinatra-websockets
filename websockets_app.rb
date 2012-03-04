EventMachine.run {
  require "./app"
  #def db
  #  $redis ||= Redis.new(REDIS_CONFIG)
  #end
  #def add_client(socket)
  #  db.sadd 'clients', socket.to_json
  #end
  #def remove_client(socket)
  #  db.srem 'clients', socket.to_json
  #end
  #def broadcast(msg)
  #  db.smembers('clients').each {|e| JSON.parse(e).send(msg) }
  #end
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(host: '0.0.0.0', port: 3000) do |ws|
    ws.on_open {
      sid = @channel.subscribe { |msg| ws.send msg }
      @channel.push "#{sid} connected!"

      ws.on_close {
        @channel.unsubscribe(sid)
        @channel.push "#{sid} disconnected!"
      }

      ws.on_message { |msg|
        @channel.push "<#{sid}>: #{msg}"
      }

      ws.on_error { |error|
        puts "Error occured: " + error.message
      }
    }
  end

}
