class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :deny_banned

  protected

  def deny_banned
    if user_signed_in? && current_user.banned?
      sign_out current_user
      redirect_to home_path, alert: "You are banned from this site."
    end
  end

  def ensure_admin
    unless user_signed_in? && current_user.admin?
      message = "No route matches [#{env['REQUEST_METHOD']}] \"#{env['PATH_INFO']}\""
      raise ActionController::RoutingError, message
    end
  end
end
