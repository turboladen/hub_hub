module ApplicationHelper
  # @param [String] title The title of the page.
  def page_title(title)
    content_for(:title, truncate(title, length: 100))
  end
end
