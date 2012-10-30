class DigestMailer < ActionMailer::Base
  default from: "digest@mindhub.org", bcc: User.digest_list

  # Gets the posts from the last 24 hours and emails the User with a light
  # breakdown of those posts.
  #
  # @param [User] user The User to email.
  def nightly_email(user)
    @posts_from_yesterday = Post.last_24_hours
    return if @posts_from_yesterday.count.zero?

    @user = user
    subject = "Your mindhub.org digest for #{Date.today.to_formatted_s(:long)}"

    mail(bcc: user.email, subject: subject)
  end
end
