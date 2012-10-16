require 'test_helper'

class AdminUserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "an admin can make another user an admin" do
    # Not sure why, but for some reason :admin fails to login here...
    admin = login :super_user
    admin.get admin_users_path
    admin.assert_response :success

    admin.xhr :put, admin_user_path(id: users(:bob).id),
      "#{users(:bob).id}-is-admin" => "true"

    admin.assert_response :success

    bob = login :bob
    assert_nothing_raised do
      bob.get admin_users_path
    end

    bob.assert_response :success
  end

  test "an admin can make another admin a regular user" do
    users(:bob).update_attribute :admin, true

    admin = login :super_user
    admin.get admin_users_path
    admin.assert_response :success

    admin.xhr :put, admin_user_path(id: users(:bob).id),
      "#{users(:bob).id}-is-admin" => "false"

    admin.assert_response :success

    bob = login :bob
    assert_raise ActionController::RoutingError do
      bob.get admin_users_path
    end

    bob.assert_redirected_to home_url
  end

  test "an admin can ban a regular logged-in user" do
    assert !users(:bob).banned?
    bob = login :bob

    admin = login :super_user
    admin.get admin_users_path
    admin.assert_response :success

    admin.xhr :put, admin_user_path(id: users(:bob).id),
      "#{users(:bob).id}-is-banned" => "true"

    admin.assert_response :success

    bob.get home_path
    bob.assert_equal "You are banned from this site.", bob.flash[:alert]
  end

  test "an admin can unban a regular user" do
    users(:bob).update_attribute :banned, true

    admin = login :super_user
    admin.get admin_users_path
    admin.assert_response :success

    admin.xhr :put, admin_user_path(id: users(:bob).id),
      "#{users(:bob).id}-is-banned" => "false"

    admin.assert_response :success

    bob = login :bob
    bob.get home_path
    bob.assert_response :success
    bob.assert_nil bob.flash[:alert]
  end

  private

  def login(user)
    open_session do |sess|
      u = users(user)

      sess.post new_user_session_path, {
        user: {
          email: u.email,
          password: 'password'
        }
      }

      assert_nil sess.flash[:alert], sess.flash[:alert]
      assert_equal "Signed in successfully.", sess.flash[:notice]
      sess.assert_response 302
    end
  end
end
