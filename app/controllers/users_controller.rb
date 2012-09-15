class UsersController < ApplicationController
  def update
    make_admin = params[:is_admin] == "true" ? true : false
    @user = User.find(params[:id])
    @user.update_attribute :admin, make_admin
    render :nothing => true
  end
end
