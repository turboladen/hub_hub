class RegistrationsController < Devise::RegistrationsController
  def update
    user = User.find_by_email(params[:user][:email])
    user.digest_email = params[:user][:digest] == "true" ? true : false
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
