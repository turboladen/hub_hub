class CommentsController < ApplicationController
  # Devise filter
  before_filter :authenticate_user!
  before_filter :ensure_admin, only: :destroy

  def create
    @post = Post.find(params[:post_id])
    @current_user = current_user
    @comment = Comment.build_from(@post, @current_user.id, params[:comment][:body])

    if @comment.save
      if params[:parent_type] == 'comment'
        parent_id = params[:parent_id]

        unless @comment.make_child_of(parent_id)
          logger.info "ERROR! Unable to make comment a child comment to ID #{parent_id}"
          flash[:error] = 'Unable to make comment a child comment'
        end
      end
    else
      flash[:error] = 'Unable to post comment'
    end

    redirect_to spoke_post_path(@post.spoke, @post)
  end

  def edit
    begin
      @comment = current_user.comments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      post = Post.find(params[:post_id])
      flash[:notice] = 'You must have created the comment to be able to edit it.'
      redirect_to spoke_post_comment_url(post.spoke, post)
    end
  end

  def update
    begin
      @comment = current_user.comments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      post = Post.find(params[:post_id])
      flash[:notice] = 'You must have created the comment to be able to edit it.'
      redirect_to spoke_post_url(post.spoke, post)

      return
    end

    if @comment.update_attributes(params[:comment])
      post = @comment.post
      flash[:notice] = 'Comment was successfully updated.'
      redirect_to spoke_post_path(post.spoke, post)
    else
      render 'edit'
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])

    if params[:disable] == 'true'
      flash[:notice] = "Disabled comment #{@comment.id}"
      @comment.destroy
    else
      flash[:notice] = "Revived comment #{@comment.id}"
      @comment.revive
    end

    respond_to do |format|
      format.js
    end
  end

  def flag
    @comment = Comment.find(params[:comment_id])

    if params[:flag_type]
      current_user.toggle_flag(@comment, params[:flag_type])
    end

    respond_to do |format|
      format.js
    end
  end
end
