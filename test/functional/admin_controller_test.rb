require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup do
    @bob = users(:bob)
  end

  test "must be logged in as an admin to view index" do
    assert_raise ActionController::RoutingError do
      get :index
    end

    sign_in @bob

    assert_raise ActionController::RoutingError do
      get :index
    end

    sign_out @bob
    sign_in users(:admin)

    assert_nothing_raised do
      get :index
    end
  end

  test "shows posts flagged as inappropriate" do
    @bob.flag posts(:post_one), :inappropriate
    sign_in users(:admin)
    get :inappropriate_items

    assert_equal 1, assigns(:flags_and_posts).size
    assert_template 'flaggings/index'
  end
end
