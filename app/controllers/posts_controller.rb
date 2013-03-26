class PostsController < ApplicationController
  # Devise filter
  before_filter :authenticate_user!, except: [:show]

  def create
    @spoke = Spoke.find(params[:spoke_id])
    @post = @spoke.posts.build(params[:post])
    @post.user = current_user

    if @post.save
      flash[:notice] = 'Your post was created.'

      redirect_to spoke_post_url(@spoke, @post)
    else
      logger.debug @post.errors.inspect
      flash[:error] = @post.errors.full_messages.join('; ')

      redirect_to @spoke
    end
  end

  def show
    begin
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      spoke = Spoke.find(params[:spoke_id])
      flash[:error] = "Couldn't find a Post with ID #{params[:id]}"
      redirect_to spoke_url(spoke)
    end
  end

  def edit
    begin
      @post = current_user.posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      post = Post.find(params[:id])
      flash[:error] = 'You must have created the post to be able to edit it.'
      redirect_to spoke_post_url(post.spoke, post)
    end
  end

  def update
    begin
      @post = current_user.posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      post = Post.find(params[:id])
      flash[:error] = 'You must have created the post to be able to update it.'
      redirect_to spoke_post_url(post.spoke, post)

      return
    end

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to spoke_post_path(@post.spoke, @post)
    else
      render 'edit'
    end
  end

  def flag
    @post = Post.find(params[:post_id])

    if params[:flag_type]
      @flag_type = params[:flag_type]
      current_user.toggle_flag(@post, @flag_type)
    end

    respond_to do |format|
      format.js
    end
  end
end
