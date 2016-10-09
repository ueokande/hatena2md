require 'nokogiri'

module Hatena2md
  module HtmlFilter
    class KeywordFilter
      def do(document)
        document.css("a.keyword").each do |a|
          a.replace a.inner_html
        end
        document
      end
    end
  end
end

