class PostMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: "poster@chat.mindhub.org"

  def receive(email)
    user = User.find_by_email(email.from)

    if user.nil?
      logger.info "Received email from an unknown address: #{email.from}"
      email_unknown_user(email.from.first)
      return
    end

    logger.info "Received email from user: #{email.from}"
    match_data = email.subject.match(/(?<spoke_name>[^:]+)\s*:\s*(?<post_title>.+)/)
    spoke = Spoke.find_by_name(match_data[:spoke_name]) || Spoke.find_by_name('Chat')

    logger.debug "Spoke name: #{spoke.name}"
    content = email.multipart? ? email.text_part.body.raw_source: email.body.raw_source
    post = spoke.posts.build(title: match_data[:post_title], content: content)
    post.user = user

    if post.save
      post.tweet(spoke_post_url(spoke.id, post))
    else
      logger.debug post.errors.full_messages
      email_unexpected_error(user, post)
    end
  end

  private

  # Sends an email to the user that tried posting to a bad spoke name.
  #
  # @param [User] user The user doing the posting.
  # @param [String] spoke_name The spoke they tried posting to.
  def email_about_bad_spoke(user, spoke_name)
    @user = user
    @spoke_name = spoke_name
    @spokes = Spoke.all

    mail(
      subject: "Hmm... there's no MindHub spoke called '#{truncate(@spoke_name, length: 40)}'",
      to: @user.email,
      template_name: 'unknown_spoke'
    ).deliver
  end

  def email_unexpected_error(user, post)
    @user = user
    @post = post

    mail(
      subject: 'Hmm... Looks like there was a problem posting your post...',
      to: @user.email,
      cc: User.admin_emails,
      template_name: 'unexpected_error'
    ).deliver

  end
end
