module Api
  module SessionsHelper
    def current_user
      @current_user ||= User.find_by(auth_token: auth_token_in_header)
    end

    private

    # Parses the auth token from an Authorization header.  Returns +nil+ if one is not found.
    #
    # @return [String, nil]
    def auth_token_in_header
      /AUTH-TOKEN\s+(?<auth_token>\S+)/ =~ request.headers['HTTP_AUTHORIZATION']

      unless auth_token
        logger.debug "No auth token found in header: '#{request.headers['HTTP_AUTHORIZATION']}'"
        return
      end

      logger.debug "Auth token found in header: '#{request.headers['HTTP_AUTHORIZATION']}'"

      auth_token
    end
  end
end
