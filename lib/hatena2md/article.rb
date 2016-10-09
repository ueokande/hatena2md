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
      @date = DateTime.strptime(data[:date], '%m/%d/%Y %H:%M:%S')
    end
  end
end
