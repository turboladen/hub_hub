module Api
  class PostsController < ApiController
    before_action :set_post, except: %i[create index]

    def index
      @posts = if params[:ids]
        Post.includes(:spoke, :owner).find(params[:ids])
      else
        Post.includes(:spoke, :owner)
      end

      respond_with @posts
    end

    def show
      respond_with @post
    end

    def create
      spoke = Spoke.find(params[:spoke_id])
      @post = spoke.posts.new(post_params)
      @post.owner = current_user || nil

      if @post.save
        respond_with :api, @post
      else
        render json: { errors: @post.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @post.update(post_params)
        head :no_content
      else
        render json: { errors: @post.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      head :no_content
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
  end
end
