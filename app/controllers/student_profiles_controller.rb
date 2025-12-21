class StudentProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_student_role
  before_action :set_profile

  def show
  end

  def new
    if current_user.student_profile
      redirect_to edit_student_profile_path
    else
      @profile = current_user.build_student_profile
    end
  end

  def create
    @profile = current_user.build_student_profile(student_profile_params)

    if @profile.save
      redirect_to dashboard_path, notice: 'Профиль студента успешно создан'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @profile.update(student_profile_params)
      redirect_to dashboard_path, notice: 'Профиль успешно обновлен'
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.student_profile || current_user.build_student_profile
  end

  def require_student_role
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user.student?
  end

  def student_profile_params
    params.require(:student_profile).permit(:group)
  end
end