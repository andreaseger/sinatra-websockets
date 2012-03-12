require 'sinatra/base'
module Sinatra
  module TemplateHelper
    def templates
      @templates ||= Dir['templates/client/*'].map {|e| { name: File.basename(e, '.mustache').sub(/^_/,''), template: IO.read(e) } }
    end

    def json data
      content_type 'application/javascript'
      data.to_json
    end
  end
end