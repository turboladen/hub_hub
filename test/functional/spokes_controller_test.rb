require 'test_helper'

class SpokesControllerTest < ActionController::TestCase
  setup do
    @spoke = spokes(:fresno)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spoke" do
    assert_difference('Spoke.count') do
      post :create, spoke: { name: @spoke.name }
    end

    assert_redirected_to spoke_path(assigns(:spoke))
  end

  test "should show spoke" do
    get :show, id: @spoke
    assert_response :success
    assert_select 'td .post-title', 2
  end

  test "should get edit" do
    get :edit, id: @spoke
    assert_response :success
  end

  test "should update spoke" do
    put :update, id: @spoke, spoke: { name: @spoke.name }
    assert_redirected_to spoke_path(assigns(:spoke))
  end

  test "should destroy spoke" do
    assert_difference('Spoke.count', -1) do
      delete :destroy, id: @spoke
    end

    assert_redirected_to spokes_path
  end
end
