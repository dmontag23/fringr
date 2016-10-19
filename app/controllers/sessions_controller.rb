class SessionsController < ApplicationController
  
  # Get request to /sessions/new (/login)
  def new
  end

	# Post request to /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = "Invalid email and/or password"
      render 'new'
    end
  end

	# Delete request to /login
  def destroy
    log_out
    redirect_to root_url
  end

end
