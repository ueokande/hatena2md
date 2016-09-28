require 'hatena2md/article'
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

        File.open(markdown_file, 'w') do |file|
          file.write(article.frontmatter)
          file.write("\n")
          file.write(article.markdown)
        end
      end
    end
  end
end
