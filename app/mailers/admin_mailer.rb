class AdminMailer < ActionMailer::Base
  def receive(email)
    logger.info "Got email to admins from: #{email.from}"

    if email.multipart?
      mail(
        subject:   email.subject,
        to:        User.admin_emails,
        from:      email.from
      ) do |format|
        format.html { email.html_part.decoded }
        format.text { email.text_part.decoded }
      end.deliver
    else
      mail(
        subject:   email.subject,
        to:        User.admin_emails,
        from:      email.from
      ) do |format|
        format.text { email.body.decoded }
      end.deliver
    end
  end
end
