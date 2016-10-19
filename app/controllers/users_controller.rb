class UsersController < ApplicationController
  
  # Get request to /users/new (/signup)
  def new
  	@user = User.new
  end

  # Post request to /users
  def create
    @user = User.new(secure_params)
    if @user.save
    	log_in @user
      flash[:success] = "Welcome to Fringr #{@user.name}!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  	# Ensures the use of strong parameters
    def secure_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
