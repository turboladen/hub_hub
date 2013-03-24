class SpokesController < ApplicationController
  # GET /spokes/1
  def show
    @sorter = if params[:sort]
      params[:sort].to_sym
    else
      :newest
    end

    @spokes = Spoke.all
    @spoke = Spoke.find(params[:id])
    @posts = @spoke.posts.send(@sorter).page(params[:page]).per(20)

    respond_to do |format|
      format.html # show.html.erb
      format.rss { render layout: false }
    end
  end

  # GET /spokes/new
  def new
    @spoke = Spoke.new
  end

  # GET /spokes/1/edit
  def edit
    @spoke = Spoke.find(params[:id])
  end

  # POST /spokes
  def create
    @spoke = Spoke.new(params[:spoke])

    if @spoke.save
      redirect_to @spoke, notice: 'Spoke was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /spokes/1
  def update
    @spoke = Spoke.find(params[:id])

    if @spoke.update_attributes(params[:spoke])
      redirect_to @spoke, notice: 'Spoke was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /spokes/1
  def destroy
    @spoke = Spoke.find(params[:id])
    @spoke.destroy

    redirect_to spokes_url
  end
end
