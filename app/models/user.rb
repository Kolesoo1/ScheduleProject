class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  has_one :student_profile, dependent: :destroy
  has_one :teacher_profile, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :courses, foreign_key: :teacher_id, dependent: :destroy

  def student?
    student_profile.present?
  end

  def teacher?
    teacher_profile.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(email, password)
    user = find_by(email: email.downcase)
    user&.authenticate(password)
  end
end
