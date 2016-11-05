class PiecesController < ApplicationController
  
	before_action :logged_in_user
	before_action :find_schedule
	before_action :correct_user, only: [:edit, :update, :show, :destroy]

  def new
  	@piece = @schedule.pieces.new
  end

  def create
    @piece = @schedule.pieces.build(secure_params)
    if @piece.save
      flash[:success] = "#{@piece.title} added"
			redirect_to @schedule
    else
    	render 'new'
    end
  end

  def edit
  end

  def update
    if @piece.update_attributes(secure_params) 
      flash[:success] = "#{@piece.title} has been updated."
      redirect_to @schedule
    else
      render 'edit' 
    end
  end

  def show
  end

  def destroy
  	@piece.destroy
    flash[:success] = "#{@piece.title} deleted"
    redirect_to @schedule
  end

  private

	  # Ensures the use of strong parameters
    def secure_params
      params.require(:piece).permit(:title, :length, :setup, :cleanup, 
      	:location_id, :rating, participants_attributes: [:id, :contact_id, :_destroy])
    end

    # Confirms the correct user for accessing pieces
    def correct_user
    	@piece = @schedule.pieces.find_by(id: params[:id])
      redirect_to root_url if @piece.nil?
    end

    # Finds the schedule associated with the piece being accessed 
    def find_schedule
      @schedule = current_user.schedules.find_by(id: params[:schedule_id])
      redirect_to root_url if @schedule.nil?
    end

end
