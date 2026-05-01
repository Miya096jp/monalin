module MarkdownHelper
  def markdown_to_html(markdown_text)
    html_string = Commonmarker.to_html(markdown_text)
    sanitize(html_string,
      tags: %w[h1 h2 h3 h4 h5 h6 p strong em ul ol li a br blockquote hr del table thead tbody tr th td],
      attributes: %w[href]
    )
  end
end
