module Api
  class PostsController < ApiController
    before_action :set_post, except: %i[create index show]

    def index
      page = params[:page] || 1
      per_page = params[:per_page] || 25

      @posts = if params[:ids]
        Kaminari.paginate_array(Post.includes(:spoke, { owner: :posts }, :responses).find(params[:ids])).
          page(page).per(per_page)
      else
        Post.includes(:spoke, { owner: :posts }, :responses).page(page).per(per_page)
      end

      respond_with :api, @posts, meta: {
        current_page: @posts.current_page,
        total_pages: @posts.total_pages,
        total_count: @posts.total_count
      }
    end

    def show
      @post = Post.includes(:responses, :owner).find(params[:id])
      respond_with :api, @post, meta: {
        total_nested_responses: @post.total_nested_responses
      }
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
