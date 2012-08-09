class App
  module Views
    class Layout < Mustache
      include Helper::Assets
      def title
        @title || "App"
      end
      def ga_site_id
        ENV['BRAIN_GA_ID']
      end
      def show_ga
        ENV['RACK_ENV'] == 'production'
      end
      def stylesheets_tag
        %{<link href="#{asset_path 'application.css'}" media="screen, projection" rel="stylesheet" type="text/css" />}
      end

      def javascripts_tag
        %{<script src="#{asset_path 'application.js'}"></script>}
      end
    end
  end
end
