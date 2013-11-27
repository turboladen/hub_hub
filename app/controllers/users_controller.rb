class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  respond_to :json

  def show
    respond_with(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user]
  end
end
