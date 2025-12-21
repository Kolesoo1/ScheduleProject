class SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    case resource.role
    when 'student'
      resource.student_profile.present? ? dashboard_path : edit_student_profile_path
    when 'teacher'
      resource.teacher_profile.present? ? dashboard_path : edit_teacher_profile_path
    when 'admin'
      admin_dashboard_path
    else
      root_path
    end
  end
end