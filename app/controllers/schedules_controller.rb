class SchedulesController < ApplicationController

	before_action :logged_in_user
	before_action :correct_user, only: [:edit, :update, :show, :destroy]

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

  def destroy
  	@schedule.destroy
    flash[:success] = "#{@schedule.name} deleted"
    redirect_to root_path
  end

  private

	  # Ensures the use of strong parameters
    def secure_params
      params.require(:schedule).permit(:name, :actor_transition_time, days_attributes: [:id, :start_date, :end_date, :_destroy])
    end

    # Confirms the correct user for accessing schedules
    def correct_user
      @schedule = current_user.schedules.find_by(id: params[:id])
      redirect_to root_url if @schedule.nil?
    end

end