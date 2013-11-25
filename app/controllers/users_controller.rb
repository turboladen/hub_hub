class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: %i[show]
  respond_to :json

=begin
  def index
    @users = User.all
    respond_with(@users)
  end
=end

  def show
    respond_with(@user)
  end

=begin
  def create
    @user = User.new(user_params)
    flash[:notice] = 'User was successfully created.' if @user.save
    respond_with(@user)
  end

  def update
    flash[:notice] = 'User was successfully updated.' if @user.update(user_params)
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end
=end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params[:user]
    end
end
