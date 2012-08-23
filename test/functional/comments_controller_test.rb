require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should create comment" do
    CommentsController.any_instance.expects(:current_user).returns(users(:bob))

    assert_difference('Comment.count') do
      post :create, { post_id: @post.id, spoke_id: @post.spoke_id,
        comment: { body: "stuff" } }
    end

    assert assigns(:post)
    assert assigns(:current_user)
    assert assigns(:comment)

    assert_redirected_to spoke_post_path(@post.spoke, @post)
  end
end
