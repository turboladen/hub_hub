class ApiController < ApplicationController
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  protected

  def not_found(exception)
    element = exception.message.match(/find all/) ? :ids : :id
    render json: { errors: { element => exception.message } },
      status: :not_found
  end

  def bad_request(exception)
    render json: { errors: { params: exception.message } },
      status: :bad_request
  end
end
