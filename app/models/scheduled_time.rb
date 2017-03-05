class ScheduledTime < ApplicationRecord

	belongs_to :day, optional: true
	belongs_to :piece
	
end
