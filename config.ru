$:.unshift File.expand_path("../config",__FILE__)
require 'environment'

MESSAGEPACK = false
require './app'

EventMachine.run do
  p "eventmachine"
  require './ws_app'

  App.run!
end