require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect new when not logged in" do
    get new_schedule_path
    assert_redirected_to login_path
    assert !flash.empty?
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Schedule.count' do
      post schedules_path, params: { schedule: { name: "Lorem ipsum", 
                                                 actor_transition_time: 35,
                                                 days_attributes: [start_date: Time.now, 
                                                                   end_date: Time.now + 5] } }
    end
    assert_redirected_to login_path
  end

  test "should redirect edit when not logged in" do
    get edit_schedule_path(@user)
    assert_redirected_to login_path
    assert !flash.empty?
  end

  test "should redirect show when not logged in" do
    get schedule_path(@user)
    assert_redirected_to login_path
    assert !flash.empty?
  end

  test "should redirect edit when logged in as other user" do
    log_in_as(@user)
    get edit_schedule_path(@other_user)
    assert_redirected_to root_path
  end

  test "should redirect show when logged in as other user" do
    log_in_as(@user)
    get schedule_path(@other_user)
    assert_redirected_to root_path
  end

  test "successful creation of schedule with friendly forwarding" do
    get new_schedule_path
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to new_schedule_path
    assert_nil session[:forwarding_url]
  end

end
