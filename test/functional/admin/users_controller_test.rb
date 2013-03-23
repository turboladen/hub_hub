require 'test_helper'


class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @bob = users(:bob)
  end

  test 'must be logged in as an admin to view users' do
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

  test 'must be logged in as an admin to view user' do
    assert_raise ActionController::RoutingError do
      get :edit, id: @bob.id
    end

    sign_in @bob

    assert_raise ActionController::RoutingError do
      get :edit, id: @bob.id
    end

    sign_out @bob
    sign_in users(:admin)
    assert_nothing_raised do
      get :edit, id: @bob.id
    end
  end

  test 'must be logged in as an admin to update user' do
    assert_raise ActionController::RoutingError do
      xhr :put, :update, id: @bob.id, "#{@bob.id}-is-admin" => 'true'
    end

    sign_in @bob
    assert_raise ActionController::RoutingError do
      xhr :put, :update, id: @bob.id, "#{@bob.id}-is-admin" => 'true'
    end
    sign_out @bob

    sign_in users(:admin)
    assert_nothing_raised do
      xhr :put, :update, id: @bob.id, "#{@bob.id}-is-admin" => 'true'
    end

    assert_response 200
  end

  test 'can make user an admin' do
    sign_in users(:admin)
    assert !@bob.admin?

    xhr :put, :update, id: @bob.id, "#{@bob.id}-is-admin" => 'true'

    assert assigns(:make_admin)
    assert_response 200
    assert_template 'admin/users/update_admin'
    updated_bob = User.find(@bob.id)
    assert updated_bob.admin?
  end

  test 'can make an admin a regular user' do
    sign_in users(:admin)
    assert !@bob.admin?
    @bob.update_attribute :admin, true

    xhr :put, :update, id: @bob.id, "#{@bob.id}-is-admin" => 'false'

    assert !assigns(:make_admin)
    assert_response 200
    updated_bob = User.find(@bob.id)
    assert !updated_bob.admin?
  end

  test 'can ban user' do
    sign_in users(:admin)
    assert !@bob.banned?

    xhr :put, :update, id: @bob.id, "#{@bob.id}-is-banned" => 'true'

    assert_response 200
    assert assigns(:ban_user)
    updated_bob = User.find(@bob.id)
    assert updated_bob.banned?
  end

  test 'can unban a banned user' do
    sign_in users(:admin)
    assert !@bob.banned?
    @bob.update_attribute :banned, true

    xhr :put, :update, id: @bob.id, "#{@bob.id}-is-banned" => 'false'

    assert_response 200
    assert !assigns(:ban_user)
    updated_bob = User.find(@bob.id)
    assert !updated_bob.banned?
  end

  test 'does not allow updating admin@mindhub.org' do
    sign_in users(:admin)

    su = users(:super_user)
    put :update, id: su.id

    assert_response 302
    assert_redirected_to admin_url
    assert_equal "Can't update super-user.", flash[:notice]
  end
end
