class ApiController < ApplicationController
  helper_method :current_user_json
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  def current_user_json
    if current_user
      UserSerializer.new(current_user, scope: current_user, root: false).to_json
    else
      {}.to_json
    end
  end
end
