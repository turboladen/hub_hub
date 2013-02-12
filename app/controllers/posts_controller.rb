class PostsController < ApplicationController
  # Devise filter
  before_filter :authenticate_user!, except: [:show]

  def create
    @spoke = Spoke.find(params[:spoke_id])
    @post = @spoke.posts.build(params[:post])
    @post.user = current_user

    if @post.save
      @post.tweet(spoke_post_url(@spoke.id, @post))
      redirect_to @spoke, notice: "Your post was created."
    else
      logger.debug @post.errors.inspect
      redirect_to @spoke, alert: @post.errors.full_messages.join("; ")
    end
  end

  def show
    @post = Post.find(params[:id])
    @current_user = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = Post.find(params[:id])

    if current_user == @post.user
      respond_to do |format|
        format.html
      end
    else
      respond_to do |format|
        format.html {
          redirect_to spoke_post_url(@post.spoke, @post),
            notice: "You must have created the post to be able to edit it."
        }
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    unless current_user == @post.user
      respond_to do |format|
        format.html {
          redirect_to spoke_post_url(@comment.post.spoke, @comment.post),
            notice: "You must have created the post to be able to update it."
        }
      end

      return
    end

    respond_to do |format|
      if @post.update_attributes(params[:content])
        format.html {
          redirect_to spoke_post_path(@post.spoke, @post),
            notice: 'Post was successfully updated.'
        }
      else
        format.html { render action: "edit" }
      end
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
