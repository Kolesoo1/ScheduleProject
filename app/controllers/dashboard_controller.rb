class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_for_admin_pages, only: [:admin_users, :admin_subjects, :admin_classrooms]

  def index
    case current_user.role
    when 'student'
      student_dashboard
    when 'teacher'
      teacher_dashboard
    when 'admin'
      admin_dashboard
    else
      redirect_to root_path
    end
  end

  def admin_users
    @users = User.all.order(created_at: :desc)
    render 'dashboard/admin/users'
  end

  def admin_subjects
    @subjects = Subject.all.order(:name)
    render 'dashboard/admin/subjects'
  end

  def admin_classrooms
    @classrooms = Classroom.all.order(:building, :number)
    render 'dashboard/admin/classrooms'
  end

  private

  def student_dashboard
    @enrollments = current_user.enrollments.includes(course: [:subject, :teacher])

    course_ids = current_user.enrolled_courses.pluck(:id)

    @schedule = ScheduleSlot.where(course_id: course_ids)
                            .includes(:course, :classroom)
                            .order(:weekday, :start_time)

    render 'dashboard/student'
  end

  def teacher_dashboard
    @courses = current_user.courses.includes(:subject, :students)

    @schedule = ScheduleSlot.where(course_id: current_user.courses.select(:id))
                            .includes(:course, :classroom)
                            .order(:weekday, :start_time)

    render 'dashboard/teacher'
  end

  def admin_dashboard
    @stats = {
      total_users: User.count,
      students: User.where(role: 'student').count,
      teachers: User.where(role: 'teacher').count,
      active_courses: Course.count,
      total_subjects: Subject.count,
      enrollments: Enrollment.count
    }

    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_courses = Course.order(created_at: :desc).limit(5)

    render 'dashboard/admin'
  end

  def require_admin_for_admin_pages
    redirect_to root_path, alert: 'Доступ запрещен' unless current_user.admin?
  end

end