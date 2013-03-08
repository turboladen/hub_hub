require 'test_helper'


class VotesControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:comment_one)
    @bob = users(:bob)
  end

  test 'does not allow upvote if not logged in' do
    xhr :post, :upvote, {
      item_type: :comment,
      item_id: @comment.id
    }

    assert_response 401
  end

  test 'upvote adds vote when item not already voted on' do
    sign_in @bob

    assert_difference('@comment.votes.count') do
      xhr :post, :upvote, {
        item_type: :comment,
        item_id: @comment.id
      }
    end

    assert_response 200
    assert_equal assigns(:upvote_count), @comment.likes.size.to_s
    assert_equal assigns(:downvote_count), @comment.dislikes.size.to_s
    assert_template 'votes/upvote'
  end

  test 'upvote removes vote when item already upvoted on by current user' do
    sign_in @bob

    @comment.liked_by @bob

    assert_difference('@comment.votes.count', -1) do
      xhr :post, :upvote, {
        item_type: :comment,
        item_id: @comment.id
      }
    end

    assert_response 200
  end

  test 'upvote adds vote when item already downvoted on by current user' do
    sign_in @bob

    @comment.downvote_from @bob

    assert_no_difference('@comment.votes.count') do
      assert_difference('@comment.likes.size') do
        assert_difference('@comment.dislikes.size', -1) do
          xhr :post, :upvote, {
            item_type: :comment,
            item_id: @comment.id
          }
        end
      end
    end

    assert_response 200
  end

  test 'does not allow downvote if not logged in' do
    xhr :post, :downvote, {
      item_type: :comment,
      item_id: @comment.id
    }

    assert_response 401
  end

  test 'downvote adds vote when item not already voted on' do
    sign_in @bob

    assert_difference('@comment.votes.count') do
      xhr :post, :downvote, {
        item_type: :comment,
        item_id: @comment.id
      }
    end

    assert_response 200
    assert_equal assigns(:upvote_count), @comment.likes.size.to_s
    assert_equal assigns(:downvote_count), @comment.dislikes.size.to_s
    assert_template 'votes/downvote'
  end

  test 'downvote removes vote when item already downvoted on by current user' do
    sign_in @bob

    @comment.downvote_from @bob

    assert_difference('@comment.votes.count', -1) do
      xhr :post, :downvote, {
        item_type: :comment,
        item_id: @comment.id
      }
    end

    assert_response 200
  end

  test 'downvote adds vote when item already upvoted on by current user' do
    sign_in @bob

    @comment.upvote_from @bob

    assert_no_difference('@comment.votes.count') do
      assert_difference('@comment.dislikes.size') do
        assert_difference('@comment.likes.size', -1) do
          xhr :post, :downvote, {
            item_type: :comment,
            item_id: @comment.id
          }
        end
      end
    end

    assert_response 200
  end
end
