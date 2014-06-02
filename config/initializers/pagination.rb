class Kaminari::Helpers::Tag
  def page_url_for(page)
    url = @params.merge(@param_name => (page <= 1 ? nil : page))
    url = @options[:url].call(page) if @options[:url].respond_to? :call

    @template.url_for url
  end
end
