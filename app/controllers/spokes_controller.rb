class SpokesController < ApplicationController
  before_filter :ensure_admin, except: [:index, :show]

  # GET /spokes
  def index
    @sorter = sorter
    @posts = Post.send(@sorter).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  # GET /spokes/1
  def show
    @sorter = sorter
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

  private

  # Figures out the sort method for posts based on whether the :sort param was
  # given or not.
  #
  # @return [String] The :sort param if given and is one of Post.sort_options,
  #   otherwise 'newest'.
  def sorter
    if params[:sort] && Post.sort_options.include?(params[:sort])
      params[:sort]
    else
      'newest'
    end
  end
end
