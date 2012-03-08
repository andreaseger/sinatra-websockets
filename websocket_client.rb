require 'eventmachine'
require 'em-http-request'

MESSAGEPACK = false

if MESSAGEPACK
  require 'msgpack'
else
  require 'json'
end

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

class KeyboardHandler < EM::Connection
  include EM::Protocols::LineText2

  attr_reader :http

  def initialize(h)
    @http = h
  end

  def receive_line(data)
    @http.send p(msg: data)
  end
end

EventMachine.run {
  http = EventMachine::HttpRequest.new("ws://0.0.0.0:3000").get :timeout => 0

  http.errback { puts "oops" }
  http.callback {
    puts "WebSocket connected!"
    http.send p(msg: "Hello client")
  }

  http.stream { |msg|
    m = u msg
    print "#{m['sid']}>: #{m['msg']}\n"
    #print m['msg']
  }
  
  EventMachine.open_keyboard(KeyboardHandler, http)
}