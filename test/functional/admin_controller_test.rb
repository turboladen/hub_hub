require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup do
    @bob = users(:bob)
  end

  test "must be logged in as an admin to view inappropriate items" do
    assert_raise ActionController::RoutingError do
      get :inappropriate_items
    end

    sign_in @bob

    assert_raise ActionController::RoutingError do
      get :inappropriate_items
    end

    sign_out @bob
    sign_in users(:admin)
    assert_nothing_raised do
      get :inappropriate_items
    end
  end

  test "shows posts flagged as inappropriate" do
    @bob.flag posts(:post_one), :inappropriate
    sign_in users(:admin)
    get :inappropriate_items

    assert_equal 1, assigns(:flags_and_posts).size
    assert_template 'flaggings/index'
  end

  test "must be logged in as an admin to view users" do
    assert_raise ActionController::RoutingError do
      get :index_users
    end

    sign_in @bob

    assert_raise ActionController::RoutingError do
      get :index_users
    end

    sign_out @bob
    sign_in users(:admin)
    assert_nothing_raised do
      get :index_users
    end
  end

  test "must be logged in as an admin to view user" do
    assert_raise ActionController::RoutingError do
      get :show_user, id: @bob.id
    end

    sign_in @bob

    assert_raise ActionController::RoutingError do
      get :show_user, id: @bob.id
    end

    sign_out @bob
    sign_in users(:admin)
    assert_nothing_raised do
      get :show_user, id: @bob.id
    end
  end

  test "must be logged in as an admin to update user" do
    assert_raise ActionController::RoutingError do
      xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-admin" => "true"
    end

    sign_in @bob
    assert_raise ActionController::RoutingError do
      xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-admin" => "true"
    end
    sign_out @bob

    sign_in users(:admin)
    assert_nothing_raised do
      xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-admin" => "true"
    end

    assert_response 200
  end

  test "must be logged in as an admin to set digest options" do
    assert_raise ActionController::RoutingError do
      get :digest_email_settings, send_time: "10:30"
    end

    sign_in @bob
    assert_raise ActionController::RoutingError do
      get :digest_email_settings, send_time: "10:30"
    end
    sign_out @bob

    sign_in users(:admin)
    assert_nothing_raised do
      get :digest_email_settings, send_time: "10:30"
    end
  end

  test "can make user an admin" do
    sign_in users(:admin)
    assert !@bob.admin?

    xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-admin" => "true"

    assert assigns(:make_admin)
    assert_response 200
    assert_template 'update_user_admin'
    updated_bob = User.find(@bob.id)
    assert updated_bob.admin?
  end

  test "can make an admin a regular user" do
    sign_in users(:admin)
    assert !@bob.admin?
    @bob.update_attribute :admin, true

    xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-admin" => "false"

    assert !assigns(:make_admin)
    assert_response 200
    updated_bob = User.find(@bob.id)
    assert !updated_bob.admin?
  end

  test "can ban user" do
    sign_in users(:admin)
    assert !@bob.banned?

    xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-banned" => "true"

    assert assigns(:ban_user)
    assert_response 200
    updated_bob = User.find(@bob.id)
    assert updated_bob.banned?
  end

  test "can unban a banned user" do
    sign_in users(:admin)
    assert !@bob.banned?
    @bob.update_attribute :banned, true

    xhr :put, :update_user, id: @bob.id, "#{@bob.id}-is-banned" => "false"

    assert !assigns(:ban_user)
    assert_response 200
    updated_bob = User.find(@bob.id)
    assert !updated_bob.banned?
  end

  test "doesn't allow updating admin@mindhub.org" do
    sign_in users(:admin)

    su = users(:super_user)
    put :update_user, id: su.id

    assert_response 302
    assert_redirected_to admin_url
    assert_equal "Can't update super-user.", flash[:notice]
  end

  test "can update digest email setting" do
    sign_in users(:admin)
    put :update_digest_email_settings, send_time: "10:30"
    assert_equal "10:30", assigns(:send_time)
  end
end
