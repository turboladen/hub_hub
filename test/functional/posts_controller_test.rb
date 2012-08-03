require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should show post" do
    get :show, id: @post, spoke_id: @post.spoke.id
    assert_response :success
    assert_select '.breadcrumb li', @post.spoke.name
    assert_select 'h1', @post.title
    assert_select '.span8 div p', /#{@post.created_at}/
    assert_select '.span8 div p', /#{@post.user.email}/
    assert_select '.span8 div p a', 'Edit'
    assert_select '.span8 .well p', @post.content
    assert_select 'td .comment', 1
  end
end
