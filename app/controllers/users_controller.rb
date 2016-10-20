class UsersController < ApplicationController
  
  # Get request to /users/new (/signup)
  def new
  	@user = User.new
  end

  # Post request to /users
  def create
    @user = User.new(secure_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
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
