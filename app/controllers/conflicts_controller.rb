class ConflictsController < ApplicationController

	before_action :logged_in_user
  before_action :find_parent_class
  before_action :load_conflicts
  before_action :correct_user, only: :destroy

  def create
    @conflict = @parent.conflicts.build(secure_params)
    if @conflict.save
      flash.now[:success] = "Conflict added"
      @conflict = @parent.conflicts.build
    end
    render 'index'
  end
	
	def index
    @conflict = @parent.conflicts.build
	end

	def destroy
    @conflict.destroy
    flash.now[:success] = "Conflict deleted"
    @conflict = @parent.conflicts.build
    render 'index'
	end

	private

    # Finds the parent of the conflict
    def find_parent_class
      if params[:contact_id].present?
        @parent = current_user.contacts.find_by(id: params[:contact_id])
      else
        @parent = current_user.locations.find_by(id: params[:location_id])
      end
      redirect_to root_url if @parent.nil?
    end

	  # Ensures the use of strong parameters
    def secure_params
      params.require(:conflict).permit(:description, :start_time, :end_time)
    end

    def load_conflicts
      @conflicts = @parent.conflicts.paginate(page: params[:page], per_page: 10).order('start_time ASC')
    end

    # Confirms the correct user for deleting items
    def correct_user
      @conflict = @parent.conflicts.find_by(id: params[:id])
      redirect_to root_url if @conflict.nil?
    end

end