class AdminController < ApplicationController
  def index
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

  def update

  end
end
