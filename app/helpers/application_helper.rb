module ApplicationHelper
  # Allows for setting the background-color on the given tag in a view/layout.
  #
  # @param [Symbol] tag
  def tag_with_color(tag)
    capture_haml do
      if @background_color.nil?
        haml_tag tag do
          yield
        end
      else
        haml_tag tag, { style: "background-color: #{@background_color}" } do
          yield
        end
      end
    end
  end

  # @return [String] The message that should be shown to users when they click
  #   the button to flag a post or comment as inappropriate.
  def inappropriate_confirm_message
    msg = <<-MSG
Are you sure you want to flag this as inappropriate?  Flagging this will notify
moderators that you've done so.  Abusing these flags will be noted and may lead
to banning from the site.
    MSG

    msg.gsub("\n", ' ')
  end

  # If the called block returns true, return "active".  Useful for doing away
  # with conditionals in views.
  #
  # @return [String] "active" if true; nil if false.
  def active_li?(&blk)
    if blk.call
      'active'
    end
  end

  # @param [String] title The title of the page.
  def page_title(title)
    content_for(:title, truncate(title, length: 100))
  end

  # @param [String] spoke_name Name of the spoke to get the icon for.
  # @param [Boolean] white Do a white icon?
  # @return HAML tag.
  def spoke_icon(spoke_name, white=false)
    icon_class = case spoke_name
    when 'Admin'
      'icon-list'
    when 'Events'
      'icon-calendar'
    when 'Intros'
      'icon-glass'
    when 'Jobs'
      'icon-briefcase'
    when 'OT'
      'icon-random'
    when 'Politics'
      'icon-globe'
    when 'Chat'
      'icon-volume-up'
    else
      ''
    end

    icon_class << ' icon-white' if white

    haml_tag :i, class: icon_class
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
