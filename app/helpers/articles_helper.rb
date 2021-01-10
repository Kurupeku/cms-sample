module ArticlesHelper
  require 'nokogiri'

  def generate_toc_array
    result = []
    document = Nokogiri::HTML @content_html
    document.css('h2, h3, h4, h5, h6').each do |head|
      indent = head.name.gsub(/\D/, '').to_i - 2
      id = head.key?('id') ? head['id'] : encode_text(head.inner_text)
      result << { indent: indent, id: id, title: head.inner_text }
    end
    result
  end

  private

  ASCII_REGEXP = %r{[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]}.freeze

  def encode_text(text)
    encoded = ''
    text.split(//).each do |t|
      concat_encode_char encoded, t
    end
    encoded
  end

  def concat_encode_char(acc, char)
    if ASCII_REGEXP =~ char
      acc.concat char
    elsif /\s/ =~ char
      acc.concat '-'
    else
      acc.concat CGI.escape(char)
    end
    acc
  end
end
