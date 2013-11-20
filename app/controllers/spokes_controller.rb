class SpokesController < ApplicationController
  before_action :set_spoke, only: %i[show]
  respond_to :html

  # GET /spokes
  def index
    @spokes = Spoke.all
  end

  # GET /spokes/1
  def show
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
