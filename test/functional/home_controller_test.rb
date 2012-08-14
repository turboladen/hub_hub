require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select 'li .spoke', 2
    assert_select 'td .post-title', 2
  end
end
