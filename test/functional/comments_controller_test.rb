require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_one)
    @comment = comments(:comment_one)
    @bob = users(:bob)
    sign_in @bob
  end

  test "should create comment on a post" do
    assert_difference('Comment.count') do
      post :create, { post_id: @post.id, spoke_id: @post.spoke_id,
        comment: { body: "stuff" } }
    end

    assert_equal assigns(:post), @post
    assert assigns(:current_user)
    assert assigns(:comment)

    assert_redirected_to spoke_post_path(@post.spoke, @post)
  end

  test "should create comment on a comment" do
    parent_comment = Comment.build_from(@post, @bob.id, "sup")
    parent_comment.save!

    assert_difference('Comment.count') do
      post :create, {
        post_id: @post.id,
        spoke_id: @post.spoke_id,
        comment: { body: "stuff" },
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

  test "provides an edit page" do
    get :edit, spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id
    assert_equal assigns(:comment), @comment
  end

  test "allows updating" do
    put :update, { spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id },
      comment: { body: 'some new stuff' }

    assert_equal assigns(:comment), @comment
    assert_redirected_to spoke_post_path(@post.spoke, @post)
  end

  test "denies updating non-existent params" do
    put :update, { spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id },
      comment: { pants: 'this should not work' }

    assert_equal assigns(:comment), @comment
    assert_template action: 'edit'
  end

  test "allows toggling flags on comments not flagged by other users" do
    assert !@comment.flagged?

    xhr :put, :update, { spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id,
      flag_type: :inappropriate }
    assert @comment.flagged?
    assert @bob.flagged?(@comment, :inappropriate)
    assert_equal assigns(:comment), @comment
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').addClass('btn-danger')
$('#inappropriate-comment-369018563').removeClass('btn-warning')
$('#inappropriateFlag').modal('show')
    BODY

    xhr :put, :update, { spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id,
      flag_type: :inappropriate }
    assert !@comment.flagged?
    assert !@bob.flagged?(@comment, :inappropriate)
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').removeClass('btn-danger')
$('#inappropriate-comment-369018563').removeClass('btn-warning')
    BODY
  end

  test "allows toggling flags on comments flagged by other users" do
    sign_out @bob
    ricky = users(:ricky)
    ricky.toggle_flag(@comment, :inappropriate)
    sign_in @bob

    assert !@bob.flagged?(@comment,:inappropriate)

    xhr :put, :update, { spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id,
      flag_type: :inappropriate }
    assert @comment.flagged?
    assert @bob.flagged?(@comment, :inappropriate)
    assert_equal assigns(:comment), @comment
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').addClass('btn-danger')
$('#inappropriate-comment-369018563').removeClass('btn-warning')
$('#inappropriateFlag').modal('show')
    BODY

    xhr :put, :update, { spoke_id: @post.spoke_id, post_id: @post.id, id: @comment.id,
      flag_type: :inappropriate }
    assert !@bob.flagged?(@comment, :inappropriate)
    assert_response :success

    assert_equal response.body, <<-BODY
$('#inappropriate-comment-369018563').removeClass('btn-danger')
$('#inappropriate-comment-369018563').addClass('btn-warning')
    BODY
  end
end
