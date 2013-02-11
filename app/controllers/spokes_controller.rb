class SpokesController < ApplicationController
  # GET /spokes/1
  def show
    @sorter = if params[:sort]
      params[:sort].to_sym
    else
      :newest
    end

    @spoke = Spoke.find(params[:id])
    @posts = @spoke.posts.send(@sorter).page(params[:page]).per(20)
    @sort_options = Post.sort_options

    respond_to do |format|
      format.html # show.html.erb
      format.rss { render layout: false }
    end
  end

  # GET /spokes/new
  def new
    @spoke = Spoke.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /spokes/1/edit
  def edit
    @spoke = Spoke.find(params[:id])
  end

  # POST /spokes
  def create
    @spoke = Spoke.new(params[:spoke])

    respond_to do |format|
      if @spoke.save
        format.html { redirect_to @spoke, notice: 'Spoke was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /spokes/1
  def update
    @spoke = Spoke.find(params[:id])

    respond_to do |format|
      if @spoke.update_attributes(params[:spoke])
        format.html { redirect_to @spoke, notice: 'Spoke was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /spokes/1
  def destroy
    @spoke = Spoke.find(params[:id])
    @spoke.destroy

    respond_to do |format|
      format.html { redirect_to spokes_url }
    end
  end
end
