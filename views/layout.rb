class App
  module Views
    class Layout < Mustache
      def title
        "App"
      end
      def stylesheets_tag
        if @settings.try(:production?)
          '<link href="/compiled/css/application.min.css" media="screen, projection" rel="stylesheet" type="text/css" />'
        else
          '<link href="/assets/application.css" media="screen, projection" rel="stylesheet" type="text/css" />'
        end
      end

      def javascripts_tag
        if @settings.try(:production?)
          '<script src="/compiled/js/application.min.js" type="text/javascript"></script>'
        else
          '<script src="/assets/application.js" type="text/javascript"></script>'
        end
      end
    end
  end
end
