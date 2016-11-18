class SchedulesController < ApplicationController

  include SchedulesHelper

	before_action :logged_in_user
	before_action :correct_user, except: [:new, :create]
  before_action :find_pieces, only: [:show, :schedule]

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
  end

  def view
    @pieces_scheduled = @schedule.pieces.where.not(day_id: nil, start_time: nil).reorder(:day_id, :start_time).paginate(page: params[:page], per_page: 10)
    @pieces_not_scheduled = @schedule.pieces.where(day_id: nil, start_time: nil).paginate(page: params[:page], per_page: 10)
  end

  def schedule
    if @pieces.count != 0
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

    # Finds all of the pieces associated with the current schedule
    def find_pieces
      @pieces = @schedule.pieces.paginate(page: params[:page], per_page: 10)
    end

end