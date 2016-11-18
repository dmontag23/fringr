class Day < ApplicationRecord
  
  belongs_to :schedule
  has_many :pieces, dependent: :nullify

	# Validations
	validates :start_time, presence: true
	validates :end_time, presence: true
	validate :end_time_is_greater_than_start_time

  private

  	def end_time_is_greater_than_start_time
  		if start_time && end_time
  		 errors.add(:end_time, "must be later than the start time") unless start_time < end_time
  		end
  	end
  
end
