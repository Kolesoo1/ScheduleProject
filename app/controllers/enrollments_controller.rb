class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :require_student_for_enrollment, only: [:create]
  before_action :require_ownership_or_admin, only: [:destroy]

  def create
    @enrollment = current_user.enrollments.build(course: @course, status: 'active')

    if @enrollment.save
      redirect_to @course, notice: 'Вы успешно записались на курс'
    else
      redirect_to @course, alert: 'Не удалось записаться на курс'
    end
  end

  def destroy
    @enrollment = Enrollment.find(params[:id])
    @enrollment.destroy

    if current_user.admin?
      redirect_to @course, notice: 'Запись на курс удалена'
    else
      redirect_to courses_path, notice: 'Вы отписались от курса'
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def require_student_for_enrollment
    redirect_to @course, alert: 'Только студенты могут записываться на курсы' unless current_user.student?
  end

  def require_ownership_or_admin
    @enrollment = Enrollment.find(params[:id])
    unless current_user.admin? || @enrollment.student == current_user
      redirect_to @course, alert: 'У вас нет прав для этого действия'
    end
  end
end