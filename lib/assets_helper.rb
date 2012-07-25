module Assets
  module Helper
    def asset_path(source)
      "/assets/" + ::Assets.asset_path(source)
    end
  end
end
