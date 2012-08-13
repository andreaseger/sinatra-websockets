
config['channel'] = ::EM::Channel.new
config['dmp'] = ::DiffMatchPatch.new
config['redis'] = EventMachine::Hiredis.connect #(REDIS_CONFIG)
#EventMachine::Synchrony::ConnectionPool.new(:size => 5) do
#  EventMachine::Protocols::Redis.connect(REDIS_CONFIG)
#end