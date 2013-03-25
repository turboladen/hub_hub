class AdminController < ApplicationController
  layout 'admin'
  before_filter :ensure_admin

  def index
    redirect_to admin_users_path
  end

  def inappropriate_items
    @flags_and_posts = case params[:flaggable_type]
    when 'posts'
      flagged(flag: 'inappropriate', flaggable_type: 'Post')
    when 'comments'
      flagged(flag: 'inappropriate', flaggable_type: 'Comment')
    else
      flagged(flag: 'inappropriate')
    end.page(params[:page])

    render 'admin/flaggings/index'
  end

  private

  def flagged(flag: nil, flaggable_type: nil)
    if flaggable_type
      MakeFlaggable::Flagging.where(flaggable_type: flaggable_type, flag: flag)
    else
      MakeFlaggable::Flagging.where(flag: flag)
    end
  end
end
