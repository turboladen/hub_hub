class SpokesController < ApplicationController
  # GET /spokes
  # GET /spokes.json
  def index
    @spokes = Spoke.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @spokes }
    end
  end

  # GET /spokes/1
  # GET /spokes/1.json
  def show
    @spoke = Spoke.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spoke }
    end
  end

  # GET /spokes/new
  # GET /spokes/new.json
  def new
    @spoke = Spoke.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spoke }
    end
  end

  # GET /spokes/1/edit
  def edit
    @spoke = Spoke.find(params[:id])
  end

  # POST /spokes
  # POST /spokes.json
  def create
    @spoke = Spoke.new(params[:spoke])

    respond_to do |format|
      if @spoke.save
        format.html { redirect_to @spoke, notice: 'Spoke was successfully created.' }
        format.json { render json: @spoke, status: :created, location: @spoke }
      else
        format.html { render action: "new" }
        format.json { render json: @spoke.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /spokes/1
  # PUT /spokes/1.json
  def update
    @spoke = Spoke.find(params[:id])

    respond_to do |format|
      if @spoke.update_attributes(params[:spoke])
        format.html { redirect_to @spoke, notice: 'Spoke was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spoke.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spokes/1
  # DELETE /spokes/1.json
  def destroy
    @spoke = Spoke.find(params[:id])
    @spoke.destroy

    respond_to do |format|
      format.html { redirect_to spokes_url }
      format.json { head :no_content }
    end
  end
end
