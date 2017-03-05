class SchedulesController < ApplicationController

  include SchedulesHelper

	before_action :logged_in_user
	before_action :correct_user, except: [:new, :create]
  before_action :check_nonnull_locations, only: :schedule

  def new
  	@schedule = current_user.schedules.new
  	@schedule.days.build
  end

  def create
    @schedule = current_user.schedules.build(secure_params)
    if @schedule.save
      flash[:success] = "#{@schedule.name} added"
			redirect_to @schedule
    else
    	render 'new'
    end
  end

  def edit
  end

  def update
    if @schedule.update_attributes(secure_params) 
      flash[:success] = "#{@schedule.name} has been updated."
      redirect_to @schedule
    else
      render 'edit'
    end
  end

  def show
    @pieces = @schedule.pieces.paginate(page: params[:page], per_page: 10)
  end

  def view
  end

  def schedule
    if @pieces_to_check.count != 0
      @pieces_to_check.each { |piece| piece.scheduled_times.each { |time| time.update_attributes(day: nil, start_time: nil) } }
      schedule_all_pieces
      flash[:success] = "Your schedule has been sucessfully created"
      redirect_to view_schedule_path(@schedule)
    else
      flash.now[:danger] = "Please add pieces to schedule"
      render 'show'
    end
  end

  def destroy
  	@schedule.destroy
    flash[:success] = "#{@schedule.name} deleted"
    redirect_to root_path
  end

  private

	  # Ensures the use of strong parameters
    def secure_params
      params.require(:schedule).permit(:name, :actor_transition_time, days_attributes: [:id, :start_time, :end_time, :_destroy])
    end

    # Confirms the correct user for accessing schedules
    def correct_user
      @schedule = current_user.schedules.find_by(id: params[:id])
      redirect_to root_url if @schedule.nil?
    end

    # Checks all locations of the pieces to be scheduled to make sure they are non-null
    def check_nonnull_locations
      @pieces_to_check = @schedule.pieces
      @pieces = @pieces_to_check.paginate(page: params[:page], per_page: 10)
      nil_locations = @pieces_to_check.where(location: nil)
      if nil_locations.count > 0
        bad_locations = ""
        nil_locations.each do |piece|
          bad_locations += "#{piece.title} "
        end
        flash.now[:danger] = "The following pieces have no location: " + bad_locations
        render 'show'
      end
    end

end