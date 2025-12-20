class Classroom < ApplicationRecord
  has_many :schedule_slots, dependent: :destroy
end
