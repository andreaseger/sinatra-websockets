module Assets
  module Helper
    def asset_path(source)
      "/assets/" + ::Assets.sprockets.find_asset(source).digest_path
    end
  end
end