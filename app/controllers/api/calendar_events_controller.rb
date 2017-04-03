module Api

  class CalendarEventsController < ApplicationController

    before_action :logged_in_user
    before_action :find_schedule

    def check_piece
      event = JSON.parse params[:event_json]
      new_start_time = Time.zone.parse(event["start"])
      day = @schedule.days.where("start_time <= ? AND end_time >= ?", new_start_time, new_start_time).first
      if !day.nil?
        piece = Piece.where(id: event["piece_id"]).first
        start_time = (new_start_time - day.start_time) / 60
        interval_length_of_piece = [start_time, start_time + piece.length]
        extended_interval = [interval_length_of_piece[0] - piece.setup, interval_length_of_piece[1] + piece.cleanup]
        @resource_monitor = Array.new
        @resource_monitor.push DayResourceMonitor.new(current_user.locations, current_user.contacts, day)
        day.scheduled_times.each do |time|
          if !time.start_time.nil? and time.id != event["time_id"]
            start_time_for_piece = (time.start_time - time.day.start_time) / 60
            extended_interval_for_piece = [start_time_for_piece - time.piece.setup, start_time_for_piece + time.piece.length + time.piece.cleanup]
            helpers.update_resource_monitor_for_scheduled_piece(0, extended_interval_for_piece, time.piece)
          end 
        end
        testjson = helpers.check_piece(day, 0, interval_length_of_piece, extended_interval, piece)
      else
        testjson = {}
        testjson[:errors] = "Invalid time. Please schedule with the day."
      end
     
      if testjson[:is_valid] 
        render json: event, status: :ok
      else 
        render json: {errors: testjson[:errors]} , status: 422
      end

    end

    def create
      event = JSON.parse params[:event_json]
      scheduled_time = ScheduledTime.where(id: event["time_id"]).first
      scheduled_time.attributes = {start_time: event["start"]}
      if scheduled_time.save(context: :manually_schedule_piece) 
        render json: event, status: :ok
      else
        render json: {errors: scheduled_time.errors.full_messages}, status: 422
      end
    end 

    def index
      events = convert_pieces_to_json_events
      render json: events, status: :ok
    end 


  private

    $colors = ['red', 'orange', 'green', 'blue', 'purple', 'aqua', 'silver', 'maroon', 'lime']
    $locations = Array.new


    # Finds the schedule associated with the piece being accessed 
    def find_schedule
      @schedule = current_user.schedules.find_by(id: params[:schedule_id])
      redirect_to root_url if @schedule.nil?
    end

    def convert_pieces_to_json_events
      events = []
      @schedule.days.each do |day|
        day.scheduled_times.each do |time|
          piece = time.piece
          $locations.push(piece.location_id)
          $locations = $locations.uniq
          events.push({title: piece.title, start: time.start_time, end: time.start_time + piece.length * 60, 
                       color: $colors[$locations.index(piece.location_id)], piece_id: piece.id, time_id: time.id})
        end
      end
      return events
    end

  end

end
