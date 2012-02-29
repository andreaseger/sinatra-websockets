$:.unshift File.expand_path("../config",__FILE__)
require 'environment'

require './app'
run Rack::URLMap.new({
  '/' => App,
  '/assets' => sprockets
})
