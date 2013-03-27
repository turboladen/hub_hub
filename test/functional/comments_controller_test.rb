require 'test_helper'


class CommentsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
    @comment = comments(:comment_one)
    @bob = users(:bob)
  end

  test 'allows toggling flags on comments not flagged by other users' do
    sign_in @bob
    assert !@comment.flagged?

    xhr :put, :flag, {
      spoke_id: @post.spoke_id,
      post_id: @post.id,
      comment_id: @comment.id,
      flag_type: :inappropriate
    }
    assert @comment.flagged?
    assert @bob.flagged?(@comment, :inappropriate)
    assert_equal assigns(:comment), @comment
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').addClass('btn-danger');
$('#inappropriate-comment-369018563').removeClass('btn-warning');
$('#inappropriateFlag').modal('show');
    BODY

    xhr :put, :flag, {
      spoke_id: @post.spoke_id,
      post_id: @post.id,
      comment_id: @comment.id,
      flag_type: :inappropriate
    }
    assert !@comment.flagged?
    assert !@bob.flagged?(@comment, :inappropriate)
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').removeClass('btn-danger');
$('#inappropriate-comment-369018563').removeClass('btn-warning');
    BODY
  end

  test 'allows toggling flags on comments flagged by other users' do
    sign_out @bob
    ricky = users(:ricky)
    ricky.toggle_flag(@comment, :inappropriate)
    sign_in @bob

    assert !@bob.flagged?(@comment,:inappropriate)

    xhr :put, :flag, {
      spoke_id: @post.spoke_id,
      post_id: @post.id,
      comment_id: @comment.id,
      flag_type: :inappropriate
    }
    assert @comment.flagged?
    assert @bob.flagged?(@comment, :inappropriate)
    assert_equal assigns(:comment), @comment
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').addClass('btn-danger');
$('#inappropriate-comment-369018563').removeClass('btn-warning');
$('#inappropriateFlag').modal('show');
    BODY

    xhr :put, :flag, {
      spoke_id: @post.spoke_id,
      post_id: @post.id,
      comment_id: @comment.id,
      flag_type: :inappropriate
    }
    assert !@bob.flagged?(@comment, :inappropriate)
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').removeClass('btn-danger');
$('#inappropriate-comment-369018563').addClass('btn-warning');
    BODY
  end
end
