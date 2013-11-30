module Api
  module SessionsHelper
    def current_user
      @current_user ||= User.find_by(auth_token: params[:auth_token])
    end
  end
end
