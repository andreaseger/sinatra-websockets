$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
$:.unshift File.expand_path("../.",__FILE__)
require 'environment'
require 'app'

map '/' do
  run App.new
end
