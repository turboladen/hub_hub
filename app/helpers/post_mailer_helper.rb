module PostMailerHelper
  # Simply builds the message/body to send back to the email address that tried
  # to post via email.
  #
  # @param [Symbol] format The email format.
  # @return [String] The message.
  def unknown_mailer_message(format)
    msg = %[Hi #{@to_address},\n\n]
    msg << %[It looks like you're trying to post an email to #{link_to('MindHub',home_url)}, but you don't have ]
    msg << "an account there (not with this email address, at least).  If you'd like to take "
    msg << 'part in the MindHub community, please sign up '

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
  # @param [Symbol] format The email format.
  # @return [String] The first part of the message.
  def unexpected_error(format)
    msg = "Hi #{@user.first_name},"
    msg << "\n\n"
    msg << 'Something weird and unexpected happened when you tried posting to MindHub via an '
    msg << "email.  The site is automatically sending this email out to let you know, and it's "
    msg << 'CCing the site Admins so they can look into what happened.  In the meantime, '
    msg << "take a look at the #{faq_link_for(format)} and make sure you follow the rules "
    msg << 'for posting via email.'
    msg << "\n\n"
    msg << "We're sorry this happened and if this is our fault, will try to fix this ASAP!  "
    msg << "Here's what you tried posting:"
    msg << "\n"

    msg
  end

  # @param [Symbol] format The email format.
  # @return [String] The first part of the message.
  def no_email(format)
    msg = "Hi #{@user.first_name},"
    msg << "\n\n"
    msg << 'We got an email from you, trying to post to MindHub, but the subject of your email '
    msg << "was empty.  We'd love to post it for you, but can't without the subject line, "
    msg << "as that's what becomes your post's title on the website.  Can you please resend "
    msg << 'the email, but with a subject line that represents your post?  You can take a '
    msg << "look at the rules for posting via email over at the #{faq_link_for(format)}."
    msg << "\n\n"
    msg << "Here's the body of your email, in case you want to copy that and paste it into a "
    msg << 'new email:'
    msg << "\n\n"

    msg
  end

  def faq_link_for(format)
    if format == :html
      "#{link_to('FAQ', faq_url)}"
    else
      "FAQ (#{faq_url})"
    end
  end
end
