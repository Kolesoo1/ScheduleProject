class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_one :student_profile, dependent: :destroy
  has_one :teacher_profile, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :courses, foreign_key: :teacher_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: { in: %w[student teacher admin] }

  after_initialize :set_default_role

  def student?
    role == 'student'
  end

  def teacher?
    role == 'teacher'
  end


  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    email == 'admin@university.ru' || teacher_profile.nil? && student_profile.nil?
  end

  def display_role
    case role
    when 'student'
      'Студент'
    when 'teacher'
      'Преподаватель'
    when 'admin'
      'Администратор'
    else
      role
    end
  end

  private

  def set_default_role
    self.role ||= 'student' if new_record?
  end


end