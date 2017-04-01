module Api

  class CalendarEventsController < ApplicationController

    before_action :logged_in_user
    before_action :find_schedule

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
          events.push({title: piece.title, start: time.start_time, end: time.start_time + piece.length * 60, color: $colors[$locations.index(piece.location_id)]})
        end
      end
      return events
    end

  end

end
