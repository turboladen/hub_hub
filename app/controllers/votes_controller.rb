class VotesController < ApplicationController
  def upvote
    item_type = params[:item_type]
    item_id = params[:item_id]
    item = instance_eval "#{item_type.capitalize}.find #{item_id}"

    if current_user.voted_up_on? item
      current_user.unvote_for item
    else
      item.liked_by current_user
    end

    redirect_to :back
  end

  def downvote
    item_type = params[:item_type]
    item_id = params[:item_id]
    item = instance_eval "#{item_type.capitalize}.find #{item_id}"

    if current_user.voted_down_on? item
      current_user.unvote_for item
    else
      item.downvote_from current_user
    end

    redirect_to :back
  end
end
