module Api
  class SessionsController < ApiController

    # POST /api/sessions.json
    def create
      @user = login(session_params[:username], session_params[:password],
        session_params[:remember_me])

      if @user
        render json: { auth_token: @user.remember_me_token }, status: :created
      else
        render json: { errors: { 'session' => 'Unauthorized.'} },
          status: :unauthorized
      end
    end

    # DELETE /api/sessions/1.json
    def destroy
      logout
      head :no_content
    end

    private

    def session_params
      params.require(:session).permit(:username, :password, :remember_me)
    end
  end
end
