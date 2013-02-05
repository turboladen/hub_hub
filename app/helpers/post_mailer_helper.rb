module PostMailerHelper
  # Simply builds the message/body to send back to the email address that tried
  # to post via email.
  #
  # @param [Symbol] format The email format.
  # @return [String] The message.
  def unknown_mailer_message(format)
    msg = <<-MSG
Hi #{@to_address},

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
end
