module Api
  class SessionsController < ApiController

    # POST /api/sessions.json
    def create
      user = User.find_by email: session_params[:email].downcase

      if user && user.authenticate(session_params[:password])
        @current_user = user

        data = {
          user_id: user.id,
          auth_token: user.auth_token
        }

        if session_params[:remember_me]
          data[:remember_token] = user.remember_token
        end

        render json: data, status: :created
      else
        render json: { errors: { 'session' => 'Unauthorized.'} },
          status: :unauthorized
      end
    end

    # Used by ember-auth for retrieving a user by the remember_token.
    #
    # POST /api/remember.json
    def remember
      user = User.find_by remember_token: session_params[:remember_token]

      if user
        @current_user = user

        data = {
          user_id: user.id,
          auth_token: user.auth_token,
          remember_token: user.remember_token
        }

        render json: data, status: :ok
      else
        render json: { errors: { 'session' => 'Unauthorized.'} },
          status: :unauthorized
      end
    end

    # DELETE /api/sessions/1.json
    def destroy
      user = User.find_by auth_token: session_params[:auth_token]

      if user
        user.generate_token(:auth_token)
        user.generate_token(:remember_token)
        user.save
        render json: { user_id: user.id }
      else
        render json: { errors: { session: 'Not logged in.' } },
          status: :unprocessable_entity
      end
    end

    private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me, :auth_token, :remember_token)
    end
  end
end
