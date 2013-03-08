require 'test_helper'


class SignUpRedirectTest < ActionDispatch::IntegrationTest
  test "user sign up redirects to the user's preference page" do
    get '/users/sign_up'
    assert_response :success

    assert_difference('User.count') do
      post user_registration_path, user: {
        first_name: 'Guy1',
        last_name: 'Smiley',
        email: 'guy1@smiley.com',
        password: 'stuff1234',
        password_confirmation: 'stuff1234'
      }
    end

    assert_redirected_to "/users/edit.#{User.last.id}"
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
  end
end
