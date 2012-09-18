class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @current_user = current_user
    @comment = Comment.build_from(@post, @current_user.id, params[:comment][:body])
    @comment.save

    if params[:parent_type] == "comment" && @comment.persisted?
      parent_comment = Comment.find(params[:parent_id])
      @comment.move_to_child_of(parent_comment)
      @comment.save
    end

    redirect_to spoke_post_path(@post.spoke, @post)
  end

  def update
    @comment = Comment.find(params[:id])

    if params[:flag_type]
      current_user.toggle_flag(@comment, params[:flag_type])
    end

    respond_to do |format|
      format.js
    end
  end
end
