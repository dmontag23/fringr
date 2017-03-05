require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = schedules(:fringe2016michael)
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
                                                 days_attributes: [start_time: Time.now, 
                                                                   end_time: Time.now + 5] } }
    end
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', "alert alert-danger"
  end

  test "should redirect edit when not logged in" do
    get edit_schedule_path(@schedule)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect update when not logged in" do
    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                          actor_transition_time: 15,
                                                          days_attributes: [start_time: Time.now, 
                                                                 end_time: Time.now + 120] } }
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect show when not logged in" do
    get schedule_path(@schedule)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect view when not logged in" do
    get view_schedule_path(@schedule)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect schedule when not logged in" do
    post view_schedule_path(@schedule)
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
    log_in_as(@other_user)
    get edit_schedule_path(@schedule)
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as other user" do
    log_in_as(@other_user)
    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                          actor_transition_time: 15,
                                                          days_attributes: [start_time: Time.now, 
                                                                 end_time: Time.now + 120] } }
    assert_redirected_to root_path
  end

  test "should redirect show when logged in as other user" do
    log_in_as(@other_user)
    get schedule_path(@schedule)
    assert_redirected_to root_path
  end

  test "should redirect view when logged in as other user" do
    log_in_as(@other_user)
    get view_schedule_path(@schedule)
    assert_redirected_to root_path
  end

  test "should redirect schedule when logged in as other user" do
    log_in_as(@other_user)
    post view_schedule_path(@schedule)
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
    assert_difference 'Schedule.count', +1 do
      assert_difference 'Day.count', +1 do
        post schedules_path, params: { schedule: { name: "Lorem pipsum", 
                                                   actor_transition_time: 15,
                                                   days_attributes: [start_time: Time.now, 
                                                                     end_time: Time.now + 120] } }
        follow_redirect!
        assert_template 'schedules/show'
        assert !flash.empty?
        assert_select 'div[class=?]', 'alert alert-success'
      end
    end
  end

  test "successful editing of schedule with friendly forwarding" do
    get edit_schedule_path(@schedule)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_schedule_path(@schedule)
    assert_nil session[:forwarding_url]
    assert_no_difference 'Schedule.count' do
      assert_difference 'Day.count', +1 do
        patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                              actor_transition_time: 45,
                                                              days_attributes: [start_time: Time.now, 
                                                                                end_time: Time.now + 120] } }
        assert_not_equal @schedule.name, @schedule.reload.name
        follow_redirect!
        assert_template 'schedules/show'
        assert !flash.empty?
        assert_select 'div[class=?]', 'alert alert-success'
      end
    end
  end

  test "unsucessful scheduling of pieces with null locations" do
    pieces(:manburns).update_attribute(:location_id, nil)
    log_in_as(@user)
    post view_schedule_path(@schedule)
    assert_template 'schedules/show'
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
    get root_path
    assert flash.empty?
  end

  test "sucessful scheduling of pieces with no null locations" do
    log_in_as(@user)
    post view_schedule_path(@schedule)
    assert_redirected_to view_schedule_path(@schedule)
    follow_redirect!
    assert_template 'schedules/view'
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-success'
    get root_path
    assert flash.empty?
  end

end
