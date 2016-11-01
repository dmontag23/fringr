require 'test_helper'

class SchedulesCreateNewTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    log_in_as @user
  end

  test "new schedule display" do
    get new_schedule_path
    assert_template 'schedules/new'
    assert_select 'title', full_title("New Schedule")
  end

  test "unsucessful addition of a schedule" do 
    assert_no_difference 'Schedule.count' do
      post schedules_path, params: { schedule: { name: "      ", 
                                                 actor_transition_time: 10,
                                                 days_attributes: [ 
                                                 	{ start_date: Time.now, end_date: Time.now + 5 },
                                                  { start_date: Time.now, end_date: Time.now + 5 } 
                                                ] } }
      assert_template 'schedules/new'
      assert_select 'div[class=?]', 'alert alert-danger'
    end
  end

  test "sucessful creation of schedules" do 
    assert_difference 'Schedule.count', +1 do
    	assert_difference 'Day.count', +2 do
	      post schedules_path, params: { schedule: { name: "Lorem Ipsum", 
                                                 actor_transition_time: 10,
                                                 days_attributes: [ 
                                                 	{ start_date: Time.now, end_date: Time.now + 5 },
                                                  { start_date: Time.now, end_date: Time.now + 5 } 
                                                ] } }
	      assert_redirected_to @user.schedules.find_by(name: "Lorem Ipsum")
	      follow_redirect!
	      assert !flash.empty?
	      assert_select 'div[class=?]', 'alert alert-success'
	    end
    end
  end

end
