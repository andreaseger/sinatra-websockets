$:.unshift File.expand_path("../config",__FILE__)
require 'environment'

MESSAGEPACK = false

EventMachine.run {
  require './websockets_app'
}