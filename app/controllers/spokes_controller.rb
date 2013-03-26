class SpokesController < ApplicationController
  before_filter :ensure_admin, except: [:show]

  # GET /spokes/1
  def show
    @sorter = if params[:sort] && Post.sort_options.include?(params[:sort].to_sym)
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
      flash[:error] = @spoke.errors.full_messages.join('; ')
      render 'new'
    end
  end

  # PUT /spokes/1
  def update
    @spoke = Spoke.find(params[:id])

    if @spoke.update_attributes(params[:spoke])
      redirect_to @spoke, notice: 'Spoke was successfully updated.'
    else
      flash[:error] = @spoke.errors.full_messages.join('; ')
      render 'edit'
    end
  end
end
