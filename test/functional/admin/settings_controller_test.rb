require 'test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase
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

  test "must be logged in as an admin to set digest options" do
    assert_raise ActionController::RoutingError do
      post :create, send_time: "10:30"
    end

    sign_in @bob
    assert_raise ActionController::RoutingError do
      post :create, send_time: "10:30"
    end
    sign_out @bob

    sign_in users(:admin)
    assert_nothing_raised do
      post :create, send_time: "10:30"
    end
  end

  test "can update digest email setting" do
    sign_in users(:admin)
    post :create, send_time: "10:30"
    assert_equal "10:30", assigns(:send_time)
  end
end
