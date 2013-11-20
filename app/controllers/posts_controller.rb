class PostsController < InheritedResources::Base
  respond_to :html
  belongs_to :spoke

  def create
    create! { resource }
  end

  private

  def permitted_params
    { post: params.fetch(:post, {}).permit(:title, :body) }
  end
end
