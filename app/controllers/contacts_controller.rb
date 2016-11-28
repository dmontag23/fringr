class ContactsController < ApplicationController

	before_action :logged_in_user
	before_action :load_contacts
	before_action :correct_user,  only: :destroy

  def create
  	@contact = current_user.contacts.build(secure_params)
    if @contact.save
      flash.now[:success] = "#{@contact.name} added"
      @contact = current_user.contacts.build
    end
    render 'index'
  end
	
	def index
		@contact = current_user.contacts.build
	end

	def destroy
		@contact.destroy
    flash.now[:success] = "#{@contact.name} deleted"
    @contact = current_user.contacts.build
    render 'index'
	end

	private

	  	# Ensures the use of strong parameters
    def secure_params
      params.require(:contact).permit(:name, :email)
    end

    def load_contacts
    	@contacts = current_user.contacts.paginate(page: params[:page], per_page: 10).order('name ASC')
    end

    # Confirms the correct user for deleting items
    def correct_user
      @contact = current_user.contacts.find_by(id: params[:id])
      redirect_to root_url if @contact.nil?
    end

end
