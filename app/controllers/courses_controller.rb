class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :require_teacher_or_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_ownership_or_admin, only: [:edit, :update, :destroy]

  def index
    if current_user.admin?
      @courses = Course.includes(:subject, :teacher).all
    elsif current_user.teacher?
      @courses = current_user.courses.includes(:subject)
    else
      @courses = Course.includes(:subject, :teacher).all
    end
  end

  def show
    @schedule_slots = @course.schedule_slots.includes(:classroom).order(:weekday, :start_time)
    @enrollments = @course.enrollments.includes(student: :student_profile)
  end

  def new
    @course = current_user.courses.build
    @subjects = Subject.all
  end

  def create
    @course = current_user.courses.build(course_params)

    if @course.save
      redirect_to @course, notice: 'Курс успешно создан'
    else
      @subjects = Subject.all
      render :new
    end
  end

  def edit
    @subjects = Subject.all
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Курс успешно обновлен'
    else
      @subjects = Subject.all
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: 'Курс успешно удален'
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def require_teacher_or_admin
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user.teacher? || current_user.admin?
  end

  def require_ownership_or_admin
    unless current_user.admin? || @course.teacher == current_user
      redirect_to root_path, alert: 'Вы не можете редактировать этот курс'
    end
  end

  def course_params
    params.require(:course).permit(:name, :subject_id, :semester, :year, :term)
  end
end