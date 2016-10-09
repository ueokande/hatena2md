require 'hatena2md/article'
require 'hatena2md/article_frontmatter'
require 'hatena2md/article_markdown_builder'
require 'mtif'

module Hatena2md
  class App
    def run(options)
      source = options[:source]
      output_base_dir = options[:output_dir]

      mtif = MTIF.load_file(source)
      mtif.posts.each do |post|
        article = Article.new(post.data)

        next if article.status != 'Publish'

        markdown_file = File.join(output_base_dir,
                                  article.date.strftime('%Y/%m/%d'),
                                  "#{article.basename}.html.md")
        FileUtils.mkdir_p File.dirname(markdown_file)

        mdBuilder = ArticleMarkdownBuilder.new(article)
        if options[:remove_keyword]
          require 'hatena2md/html_filter/keyword_filter'
          mdBuilder.add_filter(HtmlFilter::KeywordFilter.new)
        end

        frontmatter = ArticleFrontmatter.new(article).frontmatter
        markdown = mdBuilder.build

        File.open(markdown_file, 'w') do |file|
          file.write(frontmatter)
          file.write("\n")
          file.write(markdown)
        end
      end
    end
  end
end
