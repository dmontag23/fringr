require 'test_helper'

class UsersDeleteAccountTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

	test "delte user account" do
    assert_no_difference 'User.count' do
    	delete user_path(@user)
			assert_redirected_to root_path
    	delete user_path(@other_user)
			assert_redirected_to root_path
			log_in_as (@user)
    	delete user_path(@other_user)
			assert_redirected_to root_path
		end
		assert_difference 'User.count', -1 do
			delete user_path(@user)
			assert "", session[:user_id]
			assert "", cookies['remember_token']
			assert_redirected_to root_path
			assert !flash.empty?
		end

	end

end
