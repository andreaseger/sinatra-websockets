# A sample Gemfile
source "https://rubygems.org"

gem 'rake'

gem 'sinatra', :require => 'sinatra/base'
gem 'sinatra-contrib', :require => 'sinatra/contrib'
gem 'mustache', :require => 'mustache/sinatra'

gem 'thin'
gem 'em-websocket'
gem 'msgpack', :require => false
gem 'json', :require => false
gem 'diff_match_patch'

gem 'redis'

gem 'awesome_print'
gem 'colorize'

group :assets do
  gem 'therubyracer'
  gem 'sprockets'
  gem 'coffee-script'
  gem 'sass'
  gem 'uglifier', :require => false
  gem 'susy', :git => 'git://github.com/ericam/susy.git', :require => false
  gem 'compass', :git => 'git://github.com/chriseppstein/compass.git', :require => false
end

group :development do
  gem 'sinatra-reloader', :require => 'sinatra/reloader'
  gem 'capistrano'
  gem 'guard-sprockets2'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'guard-livereload'
end

group :test do
  gem 'mock_redis'
  gem 'rspec'
  gem 'mocha'
  gem 'guard-rspec'
end
