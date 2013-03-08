require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require 'mocha'

module HubHelpers
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
      assert_equal 'Signed in successfully.', sess.flash[:notice]
      sess.assert_response 302
    end
  end
end
