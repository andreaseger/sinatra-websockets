$:.unshift File.expand_path("../config",__FILE__)
require 'environment'

require './app'

EventMachine.run do
  p "eventmachine"

  App.run!
end

