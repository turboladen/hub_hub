class PostMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: 'MindHub Poster <poster@chat.mindhub.org>'

  def receive(email)
    user = User.find_by_email(email.from)

    if user.nil?
      logger.info "Received email from an unknown address: #{email.from}"
      email_unknown_user(email.from.first)
      return
    end

    logger.info "Received email from user: #{email.from}"
    match_data = email.subject.match(/(?<spoke_name>[^:]+)\s*:\s*(?<post_title>.+)/)
    post_title = match_data[:post_title]

    spoke = Spoke.find_by_name(match_data[:spoke_name])

    if spoke.nil?
      spoke = Spoke.find_by_name('Chat')
      post_title = email.subject
    end

    logger.debug "Spoke name: #{spoke.name}"
    content = if email.multipart?
      if email.html_part
        email.html_part.body.decoded
      else
        email.text_part.body.decoded
      end
    else
      email.body.decoded
    end

    post = spoke.posts.build(title: post_title, content: content)
    post.user = user

    if post.save
      post.tweet(spoke_post_url(spoke.id, post))
    else
      logger.debug post.errors.full_messages
      email_unexpected_error(user, post)
    end
  end

  private

  # Sends an email to the +from_address+ saying that that person needs to sign
  # up to be able to post via email.
  #
  # @param [String] to_address The
  def email_unknown_user(to_address)
    @to_address = to_address

    mail(
      subject: 'You should sign up for MindHub!',
      to: @to_address,
      template_name: 'unknown_address'
    ).deliver
  end

  # @param [User] user
  # @param [Post] post
  def email_unexpected_error(user, post)
    @user = user
    @post = post

    mail(
      subject: 'Hmm... Looks like there was a problem posting your post...',
      to: "#{@user.name} <#{@user.email}>",
      cc: User.admin_emails,
      template_name: 'unexpected_error'
    ).deliver
  end
end
