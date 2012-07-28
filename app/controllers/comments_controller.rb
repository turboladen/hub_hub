class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @current_user = current_user
    @comment = Comment.build_from(@post, @current_user.id, params[:comment][:body])
    @comment.save!

    if params[:parent_type] == "comment"
      parent_comment = Comment.find(params[:parent_id])
      @comment.move_to_child_of(parent_comment)
      @comment.save!
    end

    redirect_to spoke_post_path(@post.spoke, @post)
  end
end
