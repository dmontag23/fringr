require 'test_helper'

class SchedulesShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    log_in_as @user
  end
  
end
