require 'test_helper'


class CommentsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
    @comment = comments(:comment_one)
    @bob = users(:bob)
  end

  test 'does not allow commenting if not logged in' do
    assert_no_difference('Comment.count') do
      post :create, { post_id: @post.id, spoke_id: @post.spoke_id,
        comment: { body: 'stuff' } }
    end

    assert_response 302
    assert_redirected_to new_user_session_url
  end

  test 'creates comment on a post if logged in' do
    sign_in @bob

    assert_difference('Comment.count') do
      post :create, { post_id: @post.id, spoke_id: @post.spoke_id,
        comment: { body: 'stuff' } }
    end

    assert_equal assigns(:post), @post
    assert assigns(:current_user)
    assert assigns(:comment)

    assert_redirected_to spoke_post_path(@post.spoke, @post)
  end

  test 'creates comment on a comment if logged in' do
    sign_in @bob

    parent_comment = Comment.build_from(@post, @bob.id, 'sup')
    parent_comment.save!

    assert_difference('Comment.count') do
      post :create, {
        post_id: @post.id,
        spoke_id: @post.spoke_id,
        comment: { body: 'stuff' },
        parent_type: :comment,
        parent_id: parent_comment.id
      }
    end

    assert_equal assigns(:post), @post
    assert_equal assigns(:current_user), @bob
    assert assigns(:comment)
    assert_equal assigns(:comment).parent_id, parent_comment.id
    assert parent_comment.has_children?

    assert_redirected_to spoke_post_path(@post.spoke, @post)
  end

  test 'does not provide an edit page if not logged in as comment owner' do
    sign_in users(:ricky)
    get :edit, spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id

    assert_response 302
    assert_redirected_to spoke_post_comment_path(@comment.post.spoke, @comment.post, @comment)
    assert_equal 'You must have created the comment to be able to edit it.',
      flash[:notice]
  end

  test 'provides an edit page if logged in as comment owner' do
    sign_in @bob
    get :edit, spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id

    assert_equal assigns(:comment), @comment
    assert_response 200
  end

  test 'does not allow updating if logged in as not comment owner' do
    sign_in users(:karl)
    put :update, spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id,
      comment: { body: 'some new stuff' }

    assert_redirected_to spoke_post_path(@comment.post.spoke, @comment.post)
  end

  test 'allows updating if logged in as comment owner' do
    sign_in @bob
    put :update, spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id,
      comment: { body: 'some new stuff' }

    assert_redirected_to spoke_post_path(@post.spoke, @post)
    assert_equal assigns(:comment), @comment
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
$('#inappropriate-comment-369018563').addClass('btn-danger')
$('#inappropriate-comment-369018563').removeClass('btn-warning')
$('#inappropriateFlag').modal('show')
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
$('#inappropriate-comment-369018563').removeClass('btn-danger')
$('#inappropriate-comment-369018563').removeClass('btn-warning')
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
$('#inappropriate-comment-369018563').addClass('btn-danger')
$('#inappropriate-comment-369018563').removeClass('btn-warning')
$('#inappropriateFlag').modal('show')
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
$('#inappropriate-comment-369018563').removeClass('btn-danger')
$('#inappropriate-comment-369018563').addClass('btn-warning')
    BODY
  end
end
