module SchedulesHelper

	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + "_fields", f: builder)
		end
		link_to(name, "#", class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
	end

	def schedule_all_pieces
		@pieces_left_to_schedule =  []
		@schedule.pieces.each do |piece|
			piece.scheduled_times.each do |time|
				@pieces_left_to_schedule.push(piece)
			end
		end
		@resource_monitor = Array.new(@schedule.days.count) { DayResourceMonitor.new(current_user.locations, current_user.contacts) }
		run_pass
	end

	def run_pass

		# ensure every day in the schedule can initially be considered
		days_can_still_be_considered = Array.new(@schedule.days.count, true)

		# initialize an array of arrays to hold the finishing time of each piece during each day
		finishing_times_of_pieces = Array.new(@schedule.days.count) { Array.new }

		while days_can_still_be_considered.include? true do
			@schedule.days.each_with_index do |day, i|
				
				# if the day can still be considered
				if days_can_still_be_considered[i]
					finishing_times_for_day = finishing_times_of_pieces[i]  # get all of the finishing times for pieces already scheduled in this day
					
          # set the initial start time to be the beginning of the day or 5 minutes after the finishing time of the last piece
					finishing_times_for_day.empty? ? start_time = 0 : start_time = finishing_times_for_day.last + 5

					# collect all possible start times that the next piece could start at in all_possible_start_times_for_piece
					all_possible_start_times_for_piece = Array.new
					while start_time <= ((day.end_time - day.start_time)/60).to_i
						all_possible_start_times_for_piece.push(start_time)
						start_time += 5
					end

					piece_chosen = search_day(all_possible_start_times_for_piece, day, i)

					# if no piece can be fit into a day, mark the day so it is not considered again -- otherwise add a finishing time to the current day
					piece_chosen.nil? ? days_can_still_be_considered[i] = false : finishing_times_of_pieces[i] = finishing_times_for_day.push(piece_chosen.scheduled_times.where(day: day).first.start_time + piece_chosen.length)
				end
			end
		end
	end

	# keep incrementing the time interval of the day until a piece is found that fits the slot or the end of the day has passed
	def search_day(start_times, day, day_index)
		
		piece_chosen = nil
		while start_times.length > 0
			piece_chosen = select_piece(start_times[0], day, day_index, @pieces_left_to_schedule)
			if piece_chosen.nil?
				start_times.shift
			else
				@pieces_left_to_schedule.delete(piece_chosen)
				break
			end
		end

		return piece_chosen
	end

	# returns a PerformancePiece based on whether it can scheduled in the slot
	def select_piece(start_time, day, day_index, pieces_left_to_schedule)
		interval_length_of_piece = Array.new(2, start_time); #initialize the length of the piece

		pieces_to_select = pieces_left_to_schedule.dup # ensures the original array is not changed during recursion
		
		if pieces_to_select.empty?
			return nil
		else
			#scored_pieces = score_pieces
			#piece_chosen = scored_pieces.DO_SOMETHING
			piece_chosen = pieces_to_select.first # DELETE THIS
			interval_length_of_piece[1] = start_time + piece_chosen.length
			extended_interval = [interval_length_of_piece[0] - piece_chosen.setup, interval_length_of_piece[1] + piece_chosen.cleanup]
			valid_piece = check_piece(day, day_index, interval_length_of_piece, extended_interval, piece_chosen)
			if valid_piece
				schedule_piece(start_time, day, day_index, extended_interval, piece_chosen)
				return piece_chosen
			else
				pieces_to_select.delete(piece_chosen) # THIS WILL NOT WORK SINCE THERE ARE NOT DUPLICATE PIECES REPRESENTING A PIECE TO BE SCHEDULED TWICE!
				return select_piece(start_time, day, day_index, pieces_to_select)
			end
		end
	end

	def score_pieces
	end

	# returns false if a piece cannot be scheduled in a given time slot and true if it can
	def check_piece(day, day_index, interval_length_of_piece, extended_interval, piece_chosen)

		# if the piece is longer than the end time of the day, return a conflict
		return false if ((day.end_time - day.start_time)/60).to_i < interval_length_of_piece[1]


		current_day_resources = @resource_monitor[day_index]
		
		# check to make sure the piece is not already playing that day
		return false if current_day_resources.scheduled_pieces.include? piece_chosen

		#check the locations for conflicts
		location_schedule = current_day_resources.locations_schedules[piece_chosen.location_id] # get the schedule for the location the piece is to be performed in
		if !location_schedule.empty?
			location_schedule.each do |interval|
				return false if (extended_interval[0] < interval[1] && extended_interval[1] > interval[0])
			end
		end

		#check people for conflicts
		people_involved_in_piece = piece_chosen.contacts.to_a  # get all people involved in the piece
		people_involved_in_piece.each do |person|
			person_schedule = current_day_resources.people_schedules[person.id]
			if !person_schedule.empty?
				person_schedule.each do |interval|
					return false if (extended_interval[0] < interval[1] && (extended_interval[1] + @schedule.actor_transition_time) > interval[0])
				end
			end
		end

		return true

	end

	def schedule_piece(start_time, day, day_index, extended_interval, piece_chosen)
    # schedule piece in database
		piece_chosen.scheduled_times.where(start_time: nil, day: nil).first.update_attributes(start_time: start_time, day: day) 

		#update the resource monitor to include the scheduled piece
		current_day_resources = @resource_monitor[day_index]
		current_day_resources.scheduled_pieces.push piece_chosen
		current_day_resources.locations_schedules[piece_chosen.location_id].push extended_interval
		people_involved_in_piece = piece_chosen.contacts.to_a  # get all people involved in the piece
		people_involved_in_piece.each do |person|
			current_day_resources.people_schedules[person.id].push [extended_interval[0], extended_interval[1] + @schedule.actor_transition_time]
		end
	end

end