class SessionsController < ApplicationController
  
  # Get request to /sessions/new (/login)
  def new
  end

	# Post request to /login
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
      end
      redirect_to root_path
    else
      flash.now[:danger] = "Invalid email and/or password"
      render 'new'
    end
  end

	# Delete request to /login
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
