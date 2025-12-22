class ScheduleSlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :require_teacher_or_admin, except: [:index]
  before_action :set_schedule_slot, only: [:edit, :update, :destroy]

  def index
    @schedule_slots = @course.schedule_slots.includes(:classroom).order(:weekday, :start_time)
  end

  def new
    @schedule_slot = @course.schedule_slots.build
    @classrooms = Classroom.all.order(:building, :number)
  end

  def create
    @schedule_slot = @course.schedule_slots.build(schedule_slot_params)

    if @schedule_slot.save
      redirect_to course_path(@course), notice: 'Занятие успешно добавлено в расписание'
    else
      @classrooms = Classroom.all.order(:building, :number)
      render :new
    end
  end

  def edit
    @classrooms = Classroom.all.order(:building, :number)
  end

  def update
    if @schedule_slot.update(schedule_slot_params)
      redirect_to course_path(@course), notice: 'Занятие успешно обновлено'
    else
      @classrooms = Classroom.all.order(:building, :number)
      render :edit
    end
  end

  def destroy
    @schedule_slot.destroy
    redirect_to course_path(@course), notice: 'Занятие успешно удалено'
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_schedule_slot
    @schedule_slot = @course.schedule_slots.find(params[:id])
  end

  def require_teacher_or_admin
    unless current_user.admin? || @course.teacher == current_user
      redirect_to course_path(@course), alert: 'У вас нет прав для этого действия'
    end
  end

  def schedule_slot_params
    params.require(:schedule_slot).permit(:classroom_id, :weekday, :start_time, :end_time, :lesson_type)
  end
end