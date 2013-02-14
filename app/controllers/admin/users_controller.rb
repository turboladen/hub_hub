class Admin::UsersController < ApplicationController
  layout "admin"
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

    if @user.email == "admin@mindhub.org"
      redirect_to admin_url, notice: "Can't update super-user."
      return
    end

    if params["#{@user.id}-is-admin"]
      @make_admin = params["#{@user.id}-is-admin"] == "true" ? true : false

      if @user.update_attribute :admin, @make_admin
        respond_to do |format|
          format.js { render 'admin/users/update_admin' }
        end
      else
        respond_to do |format|
          format.js { render nothing: true, status: :inprocessable_entity }
        end
      end

      return
    end

    if params["#{@user.id}-is-banned"]
      @ban_user = params["#{@user.id}-is-banned"] == "true" ? true : false

      if @user.update_attribute :banned, @ban_user
        respond_to do |format|
          format.js { render 'update_ban' }
        end
      else
        respond_to do |format|
          format.js { render nothing: true, status: :inprocessable_entity }
        end
      end

      return
    end

    render nothing: true
  end
end
