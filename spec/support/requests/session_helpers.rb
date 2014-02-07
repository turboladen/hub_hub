module Requests
  module SessionHelpers
    def login(user = nil)
      user ||= FactoryGirl.create(user)
      post api_sessions_path,
        session: { email: user.email, password: user.password },
        format: :json

      user
    end

    # @param [String] token The auth_token to use for authenticating.
    def add_auth_header(token)
      request.headers['Authorization'] = "AUTH-TOKEN #{token}"
    end
  end
end
