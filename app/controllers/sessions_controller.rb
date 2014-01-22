class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(session_params[:email])

    if user && user.authenticate(session_params[:password])
      if user.admin?
        session[:user_id] = user.id
        @current_user = user
        logger.debug "Admin user just signed in: #{@current_user.email}"
        #redirect_to admin_root_path, notice: 'Logged in!'
        redirect_to admin_dashboard_path
      else
        flash.now.alert = 'You do not have access to this!'
        logger.info "User tried to login to admin page: #{user.email}"
        render :new
      end
    else
      flash.now.alert = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    @current_user = nil
    session[:user_id] = nil
    redirect_to root_url
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end

