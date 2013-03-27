class Admin::UsersController < ApplicationController
  layout 'admin'
  before_filter :ensure_admin

  def index
    @users = User.all
    render 'admin/users/index'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.super_user?
      flash[:error] = "Can't update super-user."
      redirect_to admin_url
      return
    end

    user_id = @user.id
    make_admin = boolean(params["#{user_id}-is-admin"])
    ban_user = boolean(params["#{user_id}-is-banned"])
    logger.debug "make admin: #{make_admin}"
    logger.debug "ban user: #{ban_user}"

    unless make_admin.nil?
      if @user.update_attribute :admin, make_admin
        respond_to { |format| format.js { render 'admin/users/update_admin' } }
      else
        respond_to do |format|
          format.js { render nothing: true, status: :inprocessable_entity }
        end
      end

      return
    end

    unless ban_user.nil?
      if @user.update_attribute :banned, ban_user
        respond_to { |format| format.js { render 'update_ban' } }
      else
        respond_to do |format|
          format.js { render nothing: true, status: :inprocessable_entity }
        end
      end

      return
    end

    render nothing: true
  end

  protected

  def boolean(param)
    case param
    when 'true' then true
    when 'false' then false
    else nil
    end
  end
end
