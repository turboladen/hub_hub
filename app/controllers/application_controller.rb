class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_user
    if @current_user
      logger.debug "#current_user called; #{@current_user.email}"
      return @current_user
    end

    logger.debug 'current user not set, getting from session...'

    if session[:user_id].present?
      @current_user = User.find(session[:user_id])
      logger.debug "current user now: #{@current_user.email}"
    end

    @current_user
  end

  protected

  def authenticate_user!
    current_user
  end

  private

  def access_denied(exception)
    logger.debug "access denied.  #{exception.message}"
    redirect_to new_admin_session_path, alert: exception.message
  end
end
