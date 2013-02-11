class RegistrationsController < Devise::RegistrationsController
  def update
    user = current_user
    user.digest_email = params[:user][:digest_email] == "true" ? true : false
    user.save
    super
  end
  protected

  # This is an redefinition of the method provided by
  # Devise::RegistrationsController that effectively allows for redirecting to
  # the user's preference page after signing up.
  def after_sign_up_path_for(user)
    edit_user_registration_path(user)
  end
end
