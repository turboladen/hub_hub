class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user_json
  before_filter :update_sanitized_params, if: :devise_controller?
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  private

  def access_denied(exception)
    redirect_to root_url, alert: exception.message
  end

  def current_user_json
    if current_user
      UserSerializer.new(current_user, scope: current_user, root: false).to_json
    else
      {}.to_json
    end
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end
end
