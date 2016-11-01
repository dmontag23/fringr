class SchedulesController < ApplicationController

	before_action :logged_in_user
	before_action :correct_user, only: [:edit, :show]

  def new
  	@schedule = current_user.schedules.new
  	3.times { @schedule.days.build }
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

  def show
  end

  private

	  # Ensures the use of strong parameters
    def secure_params
      params.require(:schedule).permit(:name, :actor_transition_time, days_attributes: [:start_date, :end_date])
    end

    # Confirms the correct user for accessing schedules
    def correct_user
      @schedule = current_user.schedules.find_by(id: params[:id])
      redirect_to root_url if @schedule.nil?
    end

end