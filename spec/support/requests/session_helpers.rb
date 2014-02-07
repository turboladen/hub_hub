module Requests
  module SessionHelpers
    def login(user = nil)
      @user = user || FactoryGirl.create(user)
      post api_sessions_path,
        session: { email: @user.email, password: @user.password },
        format: :json

      @user
    end

    def json_headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def with_headers(auth: false)
      if auth
        json_headers.merge!('HTTP_AUTHORIZATION' => "AUTH-TOKEN #{@user.auth_token}")
      else
        json_headers
      end
    end
  end
end
