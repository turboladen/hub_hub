module Api
  class ResponsesController < ApiController
    before_action :set_response, except: %i[create index]
    before_filter :set_respondable, only: %i[create]

    def index
      @responses = if params[:ids]
                 Response.includes(:post, :owner).find(params[:ids])
               else
                 Response.includes(:post, :owner)
               end

      respond_with :api, @responses
    end

    def show
      respond_with :api, @response
    end

    def create
      @response = Response.new(response_params)
      @response.respondable = @respondable
      @response.owner = current_user
      @response.save

      respond_with :api, @response
    end

    def update
      @response.update(response_params)
      respond_with :api, @response
    end

    def destroy
      @response.destroy
      respond_with :api, @response
    end

    private

    def set_respondable
      klass = response_params[:respondable_type].camelize.singularize.constantize
      @respondable = klass.find(response_params[:respondable_id])
    end

    def set_response
      @response = Response.find(params[:id])
      @respondable = @response.respondable
    end

    def response_params
      params.require(:response).permit(:body, :respondable_id, :respondable_type)
    end
  end
end
