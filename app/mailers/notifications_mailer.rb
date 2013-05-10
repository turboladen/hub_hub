# Mailer for Admins to send out email to regular users.
class NotificationsMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  layout 'email_poster'
  default from: 'admin@mindhub.org',
    bcc: User.regular_emails,
    cc: User.admin_emails

  # @param [Message] message
  # @return [Mail::Message]
  def new_message(message)
    @message = message

    mail(subject: "[chat.mindhub.org] #{@message.subject}")
  end
end
