class DigestMailer < ActionMailer::Base
  default from: "digest@mindhub.org"

  # Emails the nightly email to each digest subscriber.
  def nightly_email_everyone
    User.digest_list.each do |user|
      nightly_email(user).deliver
    end
  end

  # Gets the posts from the last 24 hours and emails the User with a light
  # breakdown of those posts.
  #
  # @param [User] user The User to email.
  def nightly_email(user)
    @posts_from_yesterday = Post.last_24_hours
    @comments_from_yesterday = Comment.last_24_hours

    @user = user
    subject = "Your mindhub.org digest for #{Date.today.to_formatted_s(:long)}"

    mail(to: user.email, subject: subject)
  end
end
