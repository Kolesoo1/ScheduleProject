class TeacherProfile < ApplicationRecord
  belongs_to :user
  has_many :courses, foreign_key: :teacher_id, primary_key: :user_id
end
