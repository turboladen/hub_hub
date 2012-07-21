class PostsController < ApplicationController
  def create
    @hub = Hub.find(params[:hub_id])
    @post = @hub.posts.create(params[:post])
    redirect_to hub_path(@hub)
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end
end
