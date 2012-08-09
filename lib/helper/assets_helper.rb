module Helper
  module Assets
    def asset_path(source)
      "/assets/" + ::Assets.asset_path(source)
    end
  end
end
