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

  def render_deep_comments(comment)
    comment_html(comment).html_safe
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

  def comment_html(comment, deep = 0)
    <<~"HTML"
      #{comment_main_html comment, deep}
      #{comment.children.map { |child| comment_html child, deep + 1 }.join}
    HTML
  end

  def comment_main_html(comment, deep)
    <<~"HTML"
      <li id="comment-#{comment.number}" class="article-comment#{deep.positive? ? " comment-p-#{deep}" : ''}">
        <div class="uk-flex uk-position-relative">
          <div class="uk-margin-right">
            No. #{comment.number}
          </div>
          <div class="uk-margin-right">#{comment.author_name}</div>
          <div>#{l comment.created_at}</div>
        </div>
        <div class="uk-padding-small uk-padding-remove-horizontal">
          #{parent_comment_link comment.parent}
          #{comment.content}
        </div>
        <div class="uk-margin-bottom">
          <a href="#" class="reply-to-link uk-link" data-target="#{comment.id}">#{t 'buttons.reply'}</a>
        </div>
      </li>
    HTML
  end

  def parent_comment_link(parent)
    return '' if parent.blank?

    <<~"HTML"
      <div class="uk-inline uk-width-expand">
        <a
          class="reply-preview-link uk-link"
        >
          >>#{parent.number}
        </a>
        <div class="reply-preview-dialog uk-width-expand" uk-drop="mode: click">
          #{parent_card_html parent}
        </div>
      </div><br>
    HTML
  end

  def parent_card_html(parent)
    <<~"HTML"
      <div class="uk-card uk-card-default uk-card-body uk-box-shadow-xlarge">
        <button class="uk-drop-close uk-position-small uk-position-top-right" type="button" uk-close></button>
        <div class="uk-flex uk-text-meta">
          <div class="uk-margin-right">No. #{parent.number}</div>
          <div class="uk-margin-right">#{parent.author_name}</div>
          <div>#{l parent.created_at}</div>
        </div>
        <div class="uk-padding-small uk-padding-remove-horizontal">
          #{parent_comment_link parent.parent}
          #{parent.content}
        </div>
      </div>
    HTML
  end
end
