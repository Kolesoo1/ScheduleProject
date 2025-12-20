class StudentProfile < ApplicationRecord
  belongs_to :user
  has_many :enrollments, foreign_key: :student_id, primary_key: :user_id
end
