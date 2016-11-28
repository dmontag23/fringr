module SessionsHelper
  
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

    # Stores the previous url
  def store_previous_url
    if request.referrer.nil?
      session[:forwarding_url] = root_path
    elsif request.get?  && !request.original_url.split("?").last.include?("page")
      content = request.referrer
      # take care of posting to /schedule/:id/pieces with errors
      if content.split("/").last == "pieces"
        session[:forwarding_url] = content + "/new"
      # take care of posting to /schedule/:id/pieces/:id with errors
      elsif (content.split("/").last != "new" && content.split("/")[-2] == "pieces")
        session[:forwarding_url] = content + "/edit"
      else
        session[:forwarding_url] = content
      end
    end
  end

  # Returns the user to the previous url or the root page
  def previous_url
    session[:forwarding_url] || root_path
  end
    
end
