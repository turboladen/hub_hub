class NotificationsMailer < ActionMailer::Base
  default from: 'admin@mindhub.org'

  # @param [Message] message
  # @return [Mail::Message]
  def new_message(message)
    @message = message

    mail(subject: "[chat.mindhub.org] #{@message.subject}",
      bcc: User.regular_emails, cc: User.admin_emails)
  end
end
