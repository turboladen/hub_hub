module Api
  class SpokesController < ApplicationController
    respond_to :json
    before_action :set_spoke, only: %i[show]

    # GET /spokes
    def index
      @spokes = Spoke.includes(:posts)
      respond_with @spokes
    end

    # GET /spokes/1
    def show
      respond_with @spoke
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_spoke
      @spoke = Spoke.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spoke_params
      params.require(:spoke).permit(:name, :description)
    end
  end
end
