module ApplicationHelper
  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def sign_out_link text
    link_to text, destroy_user_session_path, :method => :delete
  end
end
