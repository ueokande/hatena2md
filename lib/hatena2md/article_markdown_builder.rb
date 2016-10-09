require 'hatena2md/frontmatter_builder'
require 'nokogiri'

module Hatena2md
  class ArticleMarkdownBuilder
    def initialize(article)
      @article = article
      @filters = []
    end

    def add_filter(filter)
      @filters.push(filter)
    end

    def build()
      @document = Nokogiri::HTML.parse(@article.body)
      @filters.each do |filter|
        @document = filter.do(@document)
      end
      Html2Markdown.new(@document).build
    end
  end
end
