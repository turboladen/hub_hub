class PostMailer < ActionMailer::Base
  def receive(email)
    user = User.find_by_email(email.from)

    if user.nil?
      logger.info "Received email from an unknown address: #{email.from}"
      # Respond back to email.from saying they need to register
    end

    logger.info "Received email from user: #{email.from}"
    match_data = email.subject.match(/(?<spoke_name>[\w+]):\s+(?<post_title>)/)
    spoke = Spoke.find_by_name(match_data[:spoke_name])
    post = spoke.posts.build(title: match_data[:post_title], content: email.body)
    post.user = user

    if post.save
      post.tweet(spoke_post_url(spoke.id, post))
    else
      logger.debug post.errors.inspect
      # Send out response email saying why the post creation failed
    end
  end
end
