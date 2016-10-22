require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign up")
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
    assert_no_difference 'User.count' do
    	log_in_as(@user)
    	assert_redirected_to root_url
    end
  end

end
