class AdminController < ApplicationController
  layout "admin"
  before_filter :ensure_admin

  def index

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

  def index_users
    @users = User.all
    render 'users/index'
  end

  def show_user
    @user = User.find(params[:id])
    render 'users/show'
  end

  def update_user
    @user = User.find(params[:id])

    if @user.email == "admin@mindhub.org"
      redirect_to admin_url, notice: "Can't update super-user."
      return
    end

    if params["#{@user.id}-is-admin"]
      @make_admin = params["#{@user.id}-is-admin"] == "true" ? true : false
      @user.update_attribute :admin, @make_admin

      respond_to do |format|
        format.js { render 'update_user_admin' }
      end

      return
    end

    if params["#{@user.id}-is-banned"]
      @ban_user = params["#{@user.id}-is-banned"] == "true" ? true : false
      @user.update_attribute :banned, @ban_user

      respond_to do |format|
        format.js { render 'update_user_ban' }
      end
      return
    end

    render nothing: true
  end

  private

  def ensure_admin
    unless user_signed_in? && current_user.admin?
      message = "No route matches [#{env['REQUEST_METHOD']}] \"#{env['PATH_INFO']}\""
      raise ActionController::RoutingError, message
    end
  end
end
