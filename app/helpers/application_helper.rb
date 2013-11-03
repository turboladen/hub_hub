module ApplicationHelper
  # @param [String] title The title of the page.
  def page_title(title)
    content_for(:title, truncate(title, length: 100))
  end

  # @return [Array] The list of items to put in the footer.
  def footer_items
    [
      link_to('Creative Fresno', 'http://creativefresno.ning.com'),
      link_to('Terms of Service', tos_url),
      link_to('FAQ', faq_url),
      mail_to('admin@chat.mindhub.org', 'Email Us')
    ]
  end
end
