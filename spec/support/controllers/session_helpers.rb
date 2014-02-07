module Controllers
  module SessionHelpers
    include ApplicationHelper

    attr_reader :current_user

    def login(user=nil)
      user ||= FactoryGirl.create(:user)
      add_auth_header(user.auth_token)

      @current_user = user
    end

    # @param [String] token The auth_token to use for authenticating.
    def add_auth_header(token)
      request.headers['Authorization'] = "AUTH-TOKEN #{token}"
    end
  end
end
