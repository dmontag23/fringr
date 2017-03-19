class DayResourceMonitor

	attr_accessor :scheduled_pieces, :locations_schedules, :people_schedules

	# constructor that needs the number of locations and people in a schedule
	def initialize(locations, people, day)
		@scheduled_pieces = Array.new
		@locations_schedules = {}
		@people_schedules = {}
		load_conflicts("locations", locations, people, day)
		load_conflicts("people", locations, people, day)
	end

	#load all the conflicts for either people or locations
	def load_conflicts(person_or_location, locations, people, day)
		eval(
			%Q[#{person_or_location}.each do |item|\n
				@#{person_or_location}_schedules[item.id] = Array.new\n
				item.conflicts.where("start_time <= ? AND end_time >= ?", day.end_time, day.start_time).each do |conflict|\n
					@#{person_or_location}_schedules[item.id].push [(conflict.start_time - day.start_time) / 60, (conflict.end_time - day.start_time) / 60]\n
			  end\n
		  end])
	end

end