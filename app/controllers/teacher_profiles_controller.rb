class TeacherProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_teacher_role
  before_action :set_profile

  def show
  end

  def new
    if current_user.teacher_profile
      redirect_to edit_teacher_profile_path
    else
      @profile = current_user.build_teacher_profile
    end
  end

  def create
    @profile = current_user.build_teacher_profile(teacher_profile_params)

    if @profile.save
      redirect_to dashboard_path, notice: 'Профиль преподавателя успешно создан'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @profile.update(teacher_profile_params)
      redirect_to dashboard_path, notice: 'Профиль успешно обновлен'
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.teacher_profile || current_user.build_teacher_profile
  end

  def require_teacher_role
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user.teacher? || current_user.admin?
  end

  def teacher_profile_params
    params.require(:teacher_profile).permit(:position, :academic_degree)
  end
end