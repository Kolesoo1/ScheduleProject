class Course < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :student
  has_many :schedule_slots, dependent: :destroy
end
