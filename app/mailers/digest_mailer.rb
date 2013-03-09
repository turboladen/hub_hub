class DigestMailer < ActionMailer::Base
  default from: 'MindHub Digester <digest@chat.mindhub.org>'

  # Emails the nightly email to each digest subscriber.
  def nightly_email_everyone
    logger.info 'Starting nightly email to digest users...'

    subject = "Your mindhub.org digest for #{Date.today.to_formatted_s(:long)}"
    posts = Post.last_24_hours.all
    comments = Comment.last_24_hours.all

    User.digest_list.all.each do |user|
      nightly_email(user, subject, posts, comments)
    end

    logger.info 'Done sending nightly email to digest users.'
  end

  def nightly_email(user, subject, posts, comments)
    @user = user
    @posts_from_yesterday = posts
    @comments_from_yesterday = comments
    logger.info "Sending digest mail to #{@user.email}..."

    mail(to: "#{@user.name} <#{@user.email}>",
      subject: subject,
      template_name: 'nightly_email'
    ).deliver
  end
end
