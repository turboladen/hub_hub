module Api
  class SessionsController < ApiController

    # POST /api/sessions.json
    def create
      user = if session_params[:refresh_token]
        User.find_by remember_token: session_params[:refresh_token]
      else
        email = session_params.fetch(:email, '')
        user = User.find_by email: email

        (user && user.authenticate(session_params[:password])) ? user : nil
      end

      if user
        @current_user = user

        data = {
          user_id: user.id,
          access_token: user.auth_token,
          expires_in: 7200
        }

        render json: data, status: :created
      else
        render json: { errors: { 'session' => 'Unauthorized.'} },
          status: :unauthorized
      end
    end

    # DELETE /api/sessions/1.json
    def destroy
      user = User.find_by auth_token: session_params[:access_token]

      if user
        user.generate_token(:access_token)
        user.save
        render json: { user_id: user.id }
      else
        render json: { errors: { session: 'Not logged in.' } },
          status: :unprocessable_entity
      end
    end

    private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me, :access_token)
    end
  end
end
