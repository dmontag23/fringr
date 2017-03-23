class PiecesController < ApplicationController
  
	before_action :logged_in_user
	before_action :find_schedule
	before_action :find_piece, except: [:new, :create]
	before_action :find_locations_and_contacts, only: [:new, :create, :edit, :update]

  def new
    @piece = @schedule.pieces.new
  end

  def create
    @piece = @schedule.pieces.build(secure_params)
    @piece.mycount.to_i.times {@piece.scheduled_times.build}
    if @piece.save
      flash[:success] = "#{@piece.title} added"
			redirect_to @schedule
    else
    	render 'new'
    end
  end

  def edit
    @piece.mycount = @piece.scheduled_times.count
  end

  def update
    if @piece.update_attributes(secure_params) 
      @piece.scheduled_times.destroy_all
      @piece.mycount.to_i.times {@piece.scheduled_times.create}
      flash[:success] = "#{@piece.title} has been updated."
      redirect_to @schedule
    else
      render 'edit' 
    end
  end

  def show
  end

  def manually_schedule
  end

  def manually_schedule_piece
    @piece.attributes = secure_params
    if @piece.save(context: :manually_schedule_piece) 
       flash[:success] = "#{@piece.title} has been updated."
       redirect_to @schedule
    else
      render 'manually_schedule' 
    end
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
      	:location_id, :rating, :mycount, contact_ids: [], scheduled_times_attributes: [:id, :start_time])
    end

    # Finds the schedule associated with the piece being accessed 
    def find_schedule
      @schedule = current_user.schedules.find_by(id: params[:schedule_id])
			redirect_to root_url if @schedule.nil?
    end

    # Finds the piece being accessed
    def find_piece
    	@piece = @schedule.pieces.find_by(id: params[:id])
      redirect_to root_url if @piece.nil?
    end

    # Finds and orders all of the locations and contacts associated with the current user
    def find_locations_and_contacts
    	@locations = current_user.locations.all.order('name ASC')
    	@contacts = current_user.contacts.all.order('name ASC')
    end

end
