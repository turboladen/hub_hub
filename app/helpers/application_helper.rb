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
      "active"
    end
  end
end
