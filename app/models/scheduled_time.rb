class ScheduledTime < ApplicationRecord

	belongs_to :day, optional: true
	belongs_to :piece

	# Validations
	validate :time_is_within_scheduled_days

	    # ensures the time selected by the user is within the appropriate days of the schedule
  def time_is_within_scheduled_days
  	if piece_id and start_time
  		schedule = Schedule.find_by(id: Piece.find_by(id: piece_id).schedule_id)
	    update_day = nil
	    schedule.days.each do |day|
	  		update_day = day if Time.zone.at(start_time) >= Time.zone.at(day.start_time) and Time.zone.at(start_time) <= Time.zone.at(day.end_time)
	  		break if !update_day.nil?
	    end
	    update_day.nil? ? errors.add(:start_time, "must be during one of the scheduled times") : update_attribute(:day, update_day)
	  else
	  	update_attribute(:day, nil)
	  end
  end
	
end
