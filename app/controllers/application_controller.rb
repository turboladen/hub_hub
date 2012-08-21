class ApplicationController < ActionController::Base
  protect_from_forgery

  def sort_options
    [
      :newest,
      :most_active,
      :most_positive,
      :most_negative,
      :most_voted
    ]
  end

  def sort_posts(sort_type)
    case sort_type.to_sym
    when :newest
      Post.order('created_at').last(25)
    when :most_active
      Post.most_active
    when :most_positive
      Post.most_positive
    when :most_negative
      Post.most_negative
    when :most_voted
      Post.most_voted
    end
  end
end
