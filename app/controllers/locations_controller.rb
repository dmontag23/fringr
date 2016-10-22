class LocationsController < ApplicationController

	before_action :logged_in_user
	before_action :load_locations, only: [:create, :index]
	before_action :correct_user, only: :destroy 

  def create
  	@location = current_user.locations.build(secure_params)
    if @location.save
      flash[:success] = "#{@location.name} added"
			redirect_to locations_path
    else
    	render 'index'
    end
  end
	
	def index
		@location = current_user.locations.build
	end

	def destroy
		@location.destroy
    flash[:success] = "#{@location.name} deleted"
    redirect_to locations_path
	end

	private

	  	# Ensures the use of strong parameters
    def secure_params
      params.require(:location).permit(:name)
    end

    def load_locations
    	@locations = current_user.locations.paginate(page: params[:page], per_page: 10).order('name ASC')
    end

    # Confirms the correct user for deleting items
    def correct_user
      @location = current_user.locations.find_by(id: params[:id])
      redirect_to root_url if @location.nil?
    end

end
