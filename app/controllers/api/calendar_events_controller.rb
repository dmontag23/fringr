module Api

  class CalendarEventsController < ApplicationController

    before_action :logged_in_user
    before_action :find_schedule

    def create
      event = JSON.parse params[:event_json]
      scheduled_time = ScheduledTime.where(id: event["time_id"]).first
      scheduled_time.attributes = {day_id: event["day_id"], start_time: event["start"]}
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
                       color: $colors[$locations.index(piece.location_id)], day_id: day.id, time_id: time.id})
        end
      end
      return events
    end

  end

end
