# A sample Gemfile
source "https://rubygems.org"

gem 'rake'
gem 'foreman'

gem 'thin'
gem 'sinatra', :require => false
gem 'mustache', :require => false

gem 'goliath', :git => 'git://github.com/postrank-labs/goliath.git', :require => false
gem 'em-websocket', :require => false

gem 'msgpack', :require => false
gem 'json', :require => false
gem 'diff_match_patch'

#gem 'em-synchrony'
gem 'em-hiredis'
#gem 'hiredis'
#gem 'redis', :require => false

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
