require 'bundler'
Bundler.setup
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.mock_with :mocha

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :slow => true

  config.before :all do
    $redis = MockRedis.new
  end
  config.before :each do
    $redis.flushdb
  end
end
