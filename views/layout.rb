class App
  module Views
    class Layout < Mustache
      include Assets::Helper
      def title
        "App"
      end
      def stylesheets_tag
        %{<link href="#{asset_path 'application.css'}" media="screen, projection" rel="stylesheet" type="text/css" />}
      end

      def javascripts_tag
        %{<script src="#{asset_path 'application.js'}"</script>}
      end
    end
  end
end
