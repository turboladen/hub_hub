module Api
  class PostsController < ApiController
    before_action :set_post, except: %i[create index]

    def index
      @posts = if params[:ids]
        Post.includes(:spoke, :owner).find(params[:ids])
      else
        Post.includes(:spoke, :owner)
      end

      respond_with :api, @posts
    end

    def show
      respond_with :api, @post
    end

    def create
      @post = Post.new(post_params)
      @post.owner = current_user
      @post.save

      respond_with :api, @post
    end

    def update
      @post.update(post_params)

      respond_with :api, @post
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
      params.require(:post).permit(:title, :body, :spoke_id)
    end
  end
end
