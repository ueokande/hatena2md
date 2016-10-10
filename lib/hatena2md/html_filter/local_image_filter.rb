require 'nokogiri'

module Hatena2md
  module HtmlFilter
    class LocalImageFilter
      attr_writer :dirname, :basename;
      def do(document)
        document.css("img").each do |img|
          next unless img['src'].include?('cdn-ak.f.st-hatena.com')

          reversed = img['src'].split('/').reverse
          extension = reversed[0].split('.')[1]
          basename = @basename || reversed[0].split('.')[0]
          img['src'] = [@dirname, "#{basename}.#{extension}"].join('/')
        end
        document
      end
    end
  end
end

