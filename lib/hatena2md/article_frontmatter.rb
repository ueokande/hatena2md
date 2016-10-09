require 'hatena2md/frontmatter_builder'

module Hatena2md
  class ArticleFrontmatter
    def initialize(article)
      @article = article
    end

    def frontmatter
      FrontmatterBuilder.new
        .title(@article.title)
        .date(@article.date.strftime('%Y-%m-%d %H:%M:%S JST'))
        .tags(@article.tags.join(","))
        .build()
    end
  end
end
