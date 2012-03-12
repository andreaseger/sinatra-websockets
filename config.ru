$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
$:.unshift File.expand_path("../.",__FILE__)
require 'environment'
require 'wrapper'
require 'app'

$redis = Redis.new(REDIS_CONFIG)
EventMachine.run do
  require 'ws_app'

  App.run!
end