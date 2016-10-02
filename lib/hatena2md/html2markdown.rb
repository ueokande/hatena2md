require 'nokogiri'

class MarkdownBuilder

  def initialize(data)
    @document = Nokogiri::HTML.parse(data)
  end

  def a(node)
    if node.attribute('class').to_s == 'keyword'
      convert_children(node)
    else
      text = convert_children(node)
      href = node.attribute('href')
      "[#{text}](#{href})"
    end
  end
  
  def img(node)
    alt = node.attribute('alt')
    src = node.attribute('src')
    "![#{alt}](#{src})"
  end
  
  def strong(node)
    "**#{convert_children(node)}**"
  end

  def b(node)
    strong(node)
  end

  def i(node)
    "*#{convert_children(node)}*"
  end

  def code(node)
    "`#{convert_children(node)}`"
  end

  def tt(node)
    code(node)
  end
  
  def span(node)
    node.to_s
  end

  def cite(node)
    "<cite>#{convert_children(node)}</cite>"
  end

  def script(node)
    node.to_s
  end

  def br(node)
    "<br />"
  end

  def pre(node)
    lang = node.attribute('data-lang')
    markdown = ""
    markdown << "```#{lang}" << "\n"
    markdown << node.inner_text.strip << "\n"
    markdown << "```" << "\n\n"
  end

  def div(node)
    if node.attribute('class').to_s == 'section'
      convert_children(node)
    elsif node.attribute('class').to_s == 'seemore'
      "READMORE\n" + convert_children(node)
    end
  end

  def table(node)
    node.to_s
  end

  def h1(node)
    "# #{convert_children(node)}\n\n"
  end

  def h2(node)
    "## #{convert_children(node)}\n\n"
  end

  def h3(node)
    "### #{convert_children(node)}\n\n"
  end

  def h4(node)
    "#### #{convert_children(node)}\n\n"
  end

  def h5(node)
    "##### #{convert_children(node)}\n\n"
  end

  def ul(node)
    markdown = node.children.select{|c| c.name == 'li'}.map do |li|
      "- #{convert_children(li)}\n"
    end.join
    "#{markdown}\n"
  end

  def dl(node)
    "#{node.to_s}\n\n"
  end

  def ol(node)
    markdown = node.children.select{|c| c.name == 'li'}.map.with_index do |li, index|
      "#{index}. #{convert_children(li)}\n"
    end.join
    "#{markdown}\n"
  end

  def p(node)
    "#{convert_children(node)}\n\n"
  end

  def iframe(node)
    "#{node.to_s}\n\n"
  end

  def text(node)
    node.inner_text
  end

  def blockquote(node)
    markdown = convert_children(node)
    lines = markdown.lines.map do |line|
      "> #{line}\n".sub(/\n\n\z/, "\n")
    end
    "#{lines.join}\n"
  end

  def hr(node)
    "* * *\n\n"
  end

  def convert_children(node)
    parent_is_inline = inline_node?(node)
    node.children.map do |child|
      if (parent_is_inline && block_node?(child))
        raise "There is block tag '#{child.to_s}' in #{node.to_s}"
      end
      empty_text?(child) ? "" : send(child.name, child)
    end.join
  end

  def empty_text?(node)
    node.name == 'text' && node.inner_text.strip.empty?
  end

  def block_node?(node)
    %w(address article aside blockquote canvas dd div dl fieldset figcaption
       figure footer form h1 h2 h3 h4 h5 h6 header hgroup hr li main nav
       noscript ol output p pre section table tfoot ul video).include?(node.name)
  end

  def inline_node?(node)
    %w(b big i small tt abbr acronym cite code dfn em kbd strong samp time var
       a bdo br img map object q script span sub sup button input label select
       textarea).include?(node.name)
  end

  def build
    body = @document.root.children[0]
    convert_children(body)
  end
end
