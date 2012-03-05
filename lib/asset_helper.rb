module Assets
  module Helpers
    def asset_path(source)
      "/assets/" + ::Assets.sprockets.find_asset(source).digest_path
    end
  end
  def self.sprockets
    return @sprockets if @sprockets
    compass_gem_root = Gem.loaded_specs['compass'].full_gem_path
    @sprockets = Sprockets::Environment.new { |env| env.logger = Logger.new(STDOUT) }
    @sprockets.append_path File.join 'assets', 'javascripts'
    @sprockets.append_path File.join 'assets', 'stylesheets'
    @sprockets.append_path File.join 'assets', 'images'
    @sprockets.append_path File.join Gem.loaded_specs['compass'].full_gem_path, 'frameworks', 'compass', 'stylesheets'
    @sprockets.append_path File.join Gem.loaded_specs['compass'].full_gem_path, 'frameworks', 'compass', 'stylesheets', 'compass'
    @sprockets.append_path File.join Gem.loaded_specs['compass-susy-plugin'].full_gem_path, 'sass'
    @sprockets
  end
end
