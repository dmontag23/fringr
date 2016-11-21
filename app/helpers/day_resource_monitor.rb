class DayResourceMonitor

	attr_accessor :scheduled_pieces, :locations_schedules, :people_schedules

	# constructor that needs the number of locations and people in a schedule
	def initialize(locations, people)
		@scheduled_pieces = Array.new
		@locations_schedules = {}
		location_keys = locations.pluck(:id)
		location_keys.each{|k| @locations_schedules[k] = Array.new}
		@people_schedules = {}
		people_keys = people.pluck(:id)
		people_keys.each{|k| @people_schedules[k] = Array.new}
	end

end