class SpokesController < ApplicationController
  before_action :set_spoke, only: [:show, :edit, :update, :destroy]

  # GET /spokes
  # GET /spokes.json
  def index
    @spokes = Spoke.all
  end

  # GET /spokes/1
  # GET /spokes/1.json
  def show
  end

  # GET /spokes/new
  def new
    @spoke = Spoke.new
  end

  # GET /spokes/1/edit
  def edit
  end

  # POST /spokes
  # POST /spokes.json
  def create
    @spoke = Spoke.new(spoke_params)

    respond_to do |format|
      if @spoke.save
        format.html { redirect_to @spoke, notice: 'Spoke was successfully created.' }
        format.json { render action: 'show', status: :created, location: @spoke }
      else
        format.html { render action: 'new' }
        format.json { render json: @spoke.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spokes/1
  # PATCH/PUT /spokes/1.json
  def update
    respond_to do |format|
      if @spoke.update(spoke_params)
        format.html { redirect_to @spoke, notice: 'Spoke was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @spoke.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spokes/1
  # DELETE /spokes/1.json
  def destroy
    @spoke.destroy
    respond_to do |format|
      format.html { redirect_to spokes_url }
      format.json { head :no_content }
    end
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
