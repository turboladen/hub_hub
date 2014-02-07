module Api
  class UsersController < ApiController
    before_action :set_user, only: %i[show update destroy]

    # POST /api/users.json
    def create
      @user = User.new(user_params)

      if @user.save
        respond_with @user, location: api_user_url(@user), status: :created
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    # GET /api/users/1.json
    def show
      respond_with(@user)
    end

    # PATCH /api/users/1.json
    def update
      if @user.update(user_params)
        respond_with '', status: :no_content
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/users/1.json
    def destroy
      @user.destroy
      respond_with '', status: :no_content
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
