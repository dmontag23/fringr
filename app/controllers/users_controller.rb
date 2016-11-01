class UsersController < ApplicationController

  before_action :logged_in_user, only: :destroy 
  before_action :correct_user, only: :destroy 
  
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

  def destroy
    User.find(params[:id]).destroy
    log_out
    flash[:success] = "Account deleted"
    redirect_to root_path
  end

  private

  	# Ensures the use of strong parameters
    def secure_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms the correct user for deleting info
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user? @user
    end
    
end
