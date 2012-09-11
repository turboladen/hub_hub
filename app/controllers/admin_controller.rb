class AdminController < ApplicationController
  layout "admin"
  before_filter :ensure_admin

  def index

  end

  def inappropriate_items
    flagged = MakeFlaggable::Flagging.where(flaggable_type: "Post", flag: "inappropriate")

    @flags_and_posts = flagged.map do |flag|
      post = Post.find(flag.flaggable_id)
      {
        flag_date: flag.created_at,
        flagger: User.find(flag.flagger_id).email,
        poster: post.user.email,
        title: post.title
      }
    end
  end

  def users
    @users = User.all
  end

  private

  def ensure_admin
    unless user_signed_in? && current_user.admin?
      message = "No route matches [#{env['REQUEST_METHOD']}] \"#{env['PATH_INFO']}\""
      raise ActionController::RoutingError, message
    end
  end
end
