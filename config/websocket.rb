require 'em-synchrony'
require 'em-synchrony/em-redis'

config['channel'] = ::EM::Channel.new
config['dmp'] = ::DiffMatchPatch.new
config['redis'] = EventMachine::Synchrony::ConnectionPool.new(:size => 20) do 
  EventMachine::Protocols::Redis.connect(REDIS_CONFIG)
end