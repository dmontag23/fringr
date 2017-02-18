class ScheduledTime < ApplicationRecord

	belongs_to :day, optional: true
	belongs_to :piece

	# validations
	validates :start_time, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
	
end
