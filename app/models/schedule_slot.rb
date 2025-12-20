class ScheduleSlot < ApplicationRecord
  belongs_to :course
  belongs_to :classroom
end
