class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:first_name, :last_name, :role])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:first_name, :last_name, :avatar])
  end

  def after_sign_up_path_for(resource)
    case resource.role
    when 'student'
      edit_student_profile_path
    when 'teacher'
      edit_teacher_profile_path
    else
      root_path
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end