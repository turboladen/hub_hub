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
      "#{link_to('here', new_user_registration_url)}."
    when :text
      "here: #{new_user_registration_url}."
    else
      logger.info "#unknown_mailer_message called with unknown format: #{format}"
    end

    msg
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
what you tried posting:
    MSG
  end
end
