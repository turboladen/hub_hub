class ApplicationController < ActionController::Base
  protect_from_forgery

  # TODO: All of this should be moved into the Post model.
  def sort_options
    [
      :newest,
      :most_active,
      :most_positive,
      :most_negative,
      :most_voted
    ]
  end

  def sort_posts(sort_type, spoke=nil)
    case sort_type.to_sym
    when :newest
      return Post.order('created_at').last(25) unless spoke
      spoke.posts.order('created_at').last(25)
    when :most_active
      return spoke.posts.most_active if spoke
      Post.most_active
    when :most_negative
      return spoke.posts.most_negative if spoke
      Post.most_negative
    when :most_positive
      return spoke.posts.most_positive if spoke
      Post.most_positive
    when :most_voted
      return spoke.posts.most_voted if spoke
      Post.most_voted
    end
  end
end
