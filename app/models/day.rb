class Day < ApplicationRecord
  
  belongs_to :schedule
  has_many :scheduled_times, dependent: :nullify

	# Validations
	validates :start_time, presence: true
	validates :end_time, presence: true
	validate :end_time_is_greater_than_start_time
  validate :day_is_not_longer_than_24_hours

  private

  	def end_time_is_greater_than_start_time
  		if start_time && end_time
  		 errors.add(:end_time, "must be later than the start time") unless start_time < end_time
  		end
  	end

    # Ensures the day is less than 24 hours
    def day_is_not_longer_than_24_hours
      if start_time && end_time
       errors.add(:end_time, "must be no more than 24 hours after the start time") unless (end_time - start_time)/3600 < 24
      end
    end
  
end
