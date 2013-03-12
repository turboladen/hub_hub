class RegistrationsController < Devise::RegistrationsController
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end

    params[:user][:digest_email] = params[:user][:digest_email] == 'true' ? true : false
    @user = User.find(current_user.id)

    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end

  protected

  # This is an redefinition of the method provided by
  # Devise::RegistrationsController that effectively allows for redirecting to
  # the user's preference page after signing up.
  def after_sign_up_path_for(user)
    edit_user_registration_path(user)
  end
end
