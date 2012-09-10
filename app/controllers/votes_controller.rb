class VotesController < ApplicationController
  def upvote
    @item_type = params[:item_type]
    @item_id = params[:item_id]
    @item = instance_eval "#{@item_type.capitalize}.find #{@item_id}"

    if current_user.voted_up_on? @item
      current_user.unvote_for @item
    else
      @item.liked_by current_user
    end

    @upvote_count = @item.likes.size.to_s
    @total_vote_count = (@item.likes.size - @item.dislikes.size).to_s

    respond_to do |format|
      format.js
    end
  end

  def downvote
    @item_type = params[:item_type]
    @item_id = params[:item_id]
    @item = instance_eval "#{@item_type.capitalize}.find #{@item_id}"

    if current_user.voted_down_on? @item
      current_user.unvote_for @item
    else
      @item.downvote_from current_user
    end

    @downvote_count = @item.dislikes.size.to_s
    @total_vote_count = (@item.likes.size - @item.dislikes.size).to_s

    respond_to do |format|
      format.js
    end
  end
end
