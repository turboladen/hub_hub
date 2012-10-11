require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "must be logged in as an admin to view inappropriate items" do
    assert_raise ActionController::RoutingError do
      get :inappropriate_items
    end

    sign_in users(:bob)

    assert_raise ActionController::RoutingError do
      get :inappropriate_items
    end
  end

  test "shows posts flagged as inappropriate" do
    users(:bob).flag posts(:post_one), :inappropriate
    sign_in users(:admin)
    get :inappropriate_items

    assert_equal 1, assigns(:flags_and_posts).size
    assert_template 'flaggings/index'
  end

  test "doesn't allow updating admin@mindhub.org" do
    sign_in users(:admin)

    su = users(:super_user)
    put :update_user, id: su.id

    assert_response 302
    assert_redirected_to admin_url
    assert_equal "Can't update super-user.", flash[:notice]
  end
end
