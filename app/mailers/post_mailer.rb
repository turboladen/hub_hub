class PostMailer < ActionMailer::Base
  def receive(email)
    user = User.find_by_email(email.from)

    if user.nil?
      logger.info "Received email from an unknown address: #{email.from}"
      # Respond back to email.from saying they need to register
      email_unknown_user(email.from)
      return
    end

    logger.info "Received email from user: #{email.from}"
    match_data = email.subject.match(/(?<spoke_name>[^:]+):\s*(?<post_title>.+)/)
    spoke = Spoke.find_by_name(match_data[:spoke_name])

    if spoke.nil?
      logger.info "Received email to post to unknown spoke: #{match_data[:spoke_name]}; returning."
      return
    end

    logger.debug "Spoke name: #{spoke.name}"
    content = email.multipart? ? email.text_part.body.raw_source: email.body.raw_source
    post = spoke.posts.build(title: match_data[:post_title], content: content)
    post.user = user

    if post.save
      post.tweet(spoke_post_url(spoke.id, post))
    else
      logger.debug post.errors.full_messages
      # Send out response email saying why the post creation failed
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
end
