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

  ALERT_TYPES = [:danger, :info, :success, :warning]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :danger   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
          content_tag(:button, raw("&times;"), 'type' => 'button', :class => "close", "data-dismiss" => "alert", 'aria-hidden' => 'true') +
            msg.html_safe, :class => "alert alert-#{type} alert-dismissable")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
