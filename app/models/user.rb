class User < ApplicationRecord
  has_one :student_profile, dependent: :destroy
  has_one :teacher_profile, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :courses, foreign_key: :teacher_id, dependent: :destroy
end
