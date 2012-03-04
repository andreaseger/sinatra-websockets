class App
  module Views
    class Layout < Mustache
      include AssetHelpers
      def title
        "App"
      end
      def stylesheets_tag
        %{<link href="#{asset_path 'application.css'}" media="screen, projection" rel="stylesheet" type="text/css" />}
        #if @settings.try(:production?)
        #  '<link href="/compiled/css/application.min.css" media="screen, projection" rel="stylesheet" type="text/css" />'
        #else
        #  %{<link href="#{@assets_css || "foo"}" media="screen, projection" rel="stylesheet" type="text/css" />}
        #end
      end

      def javascripts_tag
        %{<script src="#{asset_path 'application.js'}"</script>}
        #if @settings.try(:production?)
        #  '<script src="/compiled/js/application.min.js" type="text/javascript"></script>'
        #else
        #  %{<script src="#{@assets_js || "foo"}" type="text/javascript"></script>'}
        #end
      end
    end
  end
end
