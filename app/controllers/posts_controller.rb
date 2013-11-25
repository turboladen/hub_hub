class PostsController < ApplicationController
  respond_to :json
  before_action :set_post, except: %i[create index]

  def index
    @posts = if params[:ids]
      Post.includes(:spoke, :user).find(params[:ids])
    else
      Post.includes(:spoke, :user).all
    end

    respond_with @posts
  end

  def show
    respond_with @post
  end

  def create
    spoke = Spoke.find(params[:spoke_id])
    @post = spoke.posts.new(post_params)

    if @post.save
      respond_with @post, location: @post, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      respond_with '', status: :no_content
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    respond_with '', status: :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
