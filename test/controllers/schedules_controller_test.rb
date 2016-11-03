require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = @user.schedules.find_by(name: "Fringe 2016")
  end

  test "should redirect new when not logged in" do
    get new_schedule_path
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', "alert alert-danger"
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Schedule.count' do
      post schedules_path, params: { schedule: { name: "Lorem ipsum", 
                                                 actor_transition_time: 35,
                                                 days_attributes: [start_date: Time.now, 
                                                                   end_date: Time.now + 5] } }
    end
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', "alert alert-danger"
  end

  test "should redirect edit when not logged in" do
    get edit_schedule_path(@user)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect update when not logged in" do
    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                          actor_transition_time: 15,
                                                          days_attributes: [start_date: Time.now, 
                                                                 end_date: Time.now + 120] } }
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect show when not logged in" do
    get schedule_path(@user)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Schedule.count' do
      delete schedule_path(@schedule)
    end
    assert_redirected_to login_url
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
    assert_no_difference 'Schedule.count' do
      log_in_as(@user)
      assert_redirected_to root_url
    end
  end

  test "should redirect edit when logged in as other user" do
    log_in_as(@user)
    get edit_schedule_path(@other_user)
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as other user" do
    log_in_as(@other_user)
    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                          actor_transition_time: 15,
                                                          days_attributes: [start_date: Time.now, 
                                                                 end_date: Time.now + 120] } }
    assert_redirected_to root_path
  end

  test "should redirect show when logged in as other user" do
    log_in_as(@user)
    get schedule_path(@other_user)
    assert_redirected_to root_path
  end

  test "should redirect destroy when logged in as other user" do
    log_in_as(@other_user)
    assert_no_difference 'Schedule.count' do
      delete schedule_path(@schedule)
    end
    assert_redirected_to root_path
  end

  test "successful creation of schedule with friendly forwarding" do
    get new_schedule_path
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to new_schedule_path
    assert_nil session[:forwarding_url]
    post schedules_path, params: { schedule: { name: "Lorem pipsum", 
                                               actor_transition_time: 15,
                                               days_attributes: [start_date: Time.now, 
                                                                 end_date: Time.now + 120] } }
    follow_redirect!
    assert_template 'schedules/show'
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-success'
  end

  test "successful editing of schedule with friendly forwarding" do
    get edit_schedule_path(@schedule)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_schedule_path(@schedule)
    assert_nil session[:forwarding_url]
    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                          actor_transition_time: 45,
                                                          days_attributes: [start_date: Time.now, 
                                                                            end_date: Time.now + 120] } }
    assert_not_equal @schedule.name, @schedule.reload.name
    follow_redirect!
    assert_template 'schedules/show'
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-success'
  end

end
