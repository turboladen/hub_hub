module Api
  class UsersController < ApiController
    before_action :set_user, only: %i[show update destroy]

    # POST /api/users.json
    def create
      @user = User.create(user_params)

      respond_with :api, @user
    end

    # GET /api/users/1.json
    def show
      respond_with :api, @user
    end

    # PATCH /api/users/1.json
    def update
      @user.update(user_params)

      respond_with :api, @user
    end

    # DELETE /api/users/1.json
    def destroy
      @user.destroy
      head :no_content
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
        :password, :password_confirmation)
    end
  end
end
