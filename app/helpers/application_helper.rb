module ApplicationHelper
  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def sign_out_link text
    link_to text, destroy_user_session_path, :method => :delete
  end

  def spell_out_list lst
    case lst.length
    when 0
      ''
    when 1
      lst.first
    else
      lst[0..-2].join(', ') + ' och ' + lst[-1]
    end
  end

  def render_markdown text
    BlueCloth.new(text).to_html
  end

  def short_date date
    "#{date.day} / #{date.month}"
  end
end
