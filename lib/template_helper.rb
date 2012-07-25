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

    def markdown(text)
      return if text.nil?
      text.delete! '#'
      text.gsub! /^\s*\./, ''
      md.render(text)
    end

    def md
      #@md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, hard_wrap: true, filter_html: true, autolink: true, no_intra_emphasis: true, tables: true)
    end
  end
end
