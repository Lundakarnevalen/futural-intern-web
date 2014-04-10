module MarkdownHerlper

  def markdown text
    BlueCloth.new(text).to_html
  end
end
