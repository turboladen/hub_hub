module PostMailerHelper
  # Simply builds the message/body to send back to the email address that tried
  # to post via email.
  #
  # @param [Symbol] format The email format.
  # @return [String] The message.
  def unknown_mailer_message(format)
    msg = <<-MSG
Hi #{@to_address},<br>
<br>
It looks like you're trying to post an email to #{home_url}, but you don't have
an account there (not with this email address, at least).  If you'd like to take
part in the MindHub community, please sign up
    MSG

    msg << case format
    when :html
      "#{link_to('here', new_user_registration_url)}.<br>"
    when :text
      "here: #{new_user_registration_url}."
    else
      logger.info "#unknown_mailer_message called with unknown format: #{format}"
    end

    msg
  end

  # Builds the message/body to send back to the user that tried posting to a
  # spoke that doesn't exist.
  #
  # @return [String] The message.
  def unknown_spoke_message
    <<-MSG
Hi #{@user.first_name}<br>
<br>
It looks like you tried emailing a post to a MindHub spoke called '#{@spoke_name}'
--MindHub doesn't have a spoke for that right now, but perhaps you meant to post
to a different spoke?  Or maybe you mistyped?  The subject of your email should
look like this:<br>
<br>
  [spoke name]: [post title]<br>
<br>
The spokes MindHub has available right now are:<br>
    MSG
  end

  # Message for when an unexpected error occurs.
  #
  # @return [String] The first part of the message.
  def unexpected_error
    <<-MSG
Hi #{@user.first_name},<br>
<br>
Something weird and unexpected happened when you tried posting to MindHub via an
email.  The site is automatically sending this email out to let you know, and it's
CCing the site Admins so they can look into what happened.<br>
<br>
We're sorry this happened and will try to fix this ASAP!  In the meantime, here's
what you tried posting:<br>
    MSG
  end
end
