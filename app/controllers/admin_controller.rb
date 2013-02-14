class AdminController < ApplicationController
  layout "admin"
  before_filter :ensure_admin

  def index
    redirect_to admin_users_path
  end

  def inappropriate_items
    flagged =
      MakeFlaggable::Flagging.where(flaggable_type: "Post", flag: "inappropriate")

    @flags_and_posts = flagged.map do |flag|
      post = Post.find(flag.flaggable_id)
      {
        flag_date: flag.created_at,
        flagger: User.find(flag.flagger_id).email,
        poster: post.user.email,
        title: post.title
      }
    end

    render 'flaggings/index'
  end
end
