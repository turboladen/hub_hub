class VotesController < ApplicationController
  before_filter :authenticate_user!

  def upvote
    @item_type = item_class(params[:item_type])
    @item = @item_type.find params[:item_id]

    if current_user.voted_up_on? @item
      current_user.unvote_for @item
    else
      @item.liked_by current_user
    end

    @upvote_count = @item.likes.size.to_s
    @downvote_count = @item.dislikes.size.to_s
    @total_vote_count = (@upvote_count.to_i - @downvote_count.to_i).to_s

    respond_to do |format|
      format.js
    end
  end

  def downvote
    @item_type = item_class(params[:item_type])
    @item = @item_type.find params[:item_id]

    if current_user.voted_down_on? @item
      current_user.unvote_for @item
    else
      @item.downvote_from current_user
    end

    @upvote_count = @item.likes.size.to_s
    @downvote_count = @item.dislikes.size.to_s
    @total_vote_count = (@upvote_count.to_i - @downvote_count.to_i).to_s

    respond_to do |format|
      format.js
    end
  end

  private

  def item_class(param)
    begin
      param.capitalize.constantize
    rescue NameError
      logger.info "WARNING: Someone tried voting on a object of type '#{param}'.  Possible hack attempt?"
      nil
    end
  end
end
