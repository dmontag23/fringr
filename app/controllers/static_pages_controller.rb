class StaticPagesController < ApplicationController
  
  def home
  	if logged_in?
  		@schedules = current_user.schedules.paginate(page: params[:page], per_page: 10)
  	end
  end

  def about
  end

  def contact
  end

end
