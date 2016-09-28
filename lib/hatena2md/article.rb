require 'hatena2md/html2markdown'
require 'hatena2md/frontmatter_builder'
require 'date'

module Hatena2md
  class Article
    attr_reader :title, :tags, :status, :date, :body, :basename

    def initialize(data)
      @title = data[:title]
      @tags = data[:category]
      @status = data[:status]
      @body = data[:body]
      @basename = File.basename(data[:basename].to_s)

      parsed_date = Date._strptime(data[:date], '%m/%d/%Y')
      @date = Date.new(parsed_date[:year], parsed_date[:mon], parsed_date[:mday])
    end

    def frontmatter
      FrontmatterBuilder.new
        .title(title)
        .date(date.strftime('%Y-%m-%d'))
        .tags(tags.join(","))
        .build()
    end

    def markdown
      MarkdownBuilder.new(body).build
    end
  end
end
