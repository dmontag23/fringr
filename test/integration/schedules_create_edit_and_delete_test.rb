require 'test_helper'

class SchedulesCreateEditAndDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @schedule = @user.schedules.find_by(name: "Fringe 2016")
    log_in_as @user
  end

  test "new schedule display" do
    get new_schedule_path
    assert_template 'schedules/new'
    assert_select 'title', full_title("New Schedule")
    assert_select 'a[class=?]', "remove_fields", count: 1
    assert_select 'a[class=?]', "add_fields", count: 1
  end

  test "edit schedule display" do
    get edit_schedule_path(@schedule)
    assert_template 'schedules/edit'
    assert_select 'title', full_title("Edit Schedule")
    assert_select 'a[class=?]', "remove_fields", count: 3
    assert_select 'a[class=?]', "add_fields", count: 1
  end

  test "unsucessful addition of a schedule" do 
    assert_no_difference 'Schedule.count' do
      assert_no_difference 'Day.count' do
        post schedules_path, params: { schedule: { name: "      ", 
                                                   actor_transition_time: 10,
                                                   days_attributes: [ 
                                                   	{ start_time: Time.now, end_time: Time.now + 5 },
                                                    { start_time: Time.now, end_time: Time.now + 5 } 
                                                  ] } }
        assert_template 'schedules/new'
        assert_select 'div[class=?]', 'alert alert-danger'
      end
    end
  end

  test "sucessful creation of schedules" do 
    assert_difference 'Schedule.count', +1 do
    	assert_difference 'Day.count', +2 do
	      post schedules_path, params: { schedule: { name: "Lorem Ipsum", 
                                                 actor_transition_time: 10,
                                                 days_attributes: [ 
                                                 	{ start_time: Time.now, end_time: Time.now + 5 },
                                                  { start_time: Time.now, end_time: Time.now + 5, _destroy: "1" },
                                                  { start_time: Time.now, end_time: Time.now + 5 } 
                                                ] } }
	      assert_redirected_to @user.schedules.find_by(name: "Lorem Ipsum")
	      follow_redirect!
	      assert !flash.empty?
	      assert_select 'div[class=?]', 'alert alert-success'
	    end
    end
  end

  test "unsucessful edit of a schedule" do 
    assert_no_difference 'Schedule.count' do
      assert_no_difference 'Day.count' do
        patch schedule_path(@schedule), params: { schedule: { name: "      ", 
                                                              actor_transition_time: 10,
                                                              days_attributes: [ 
                                                              { start_time: Time.now, end_time: Time.now + 5 },
                                                              { start_time: Time.now, end_time: Time.now + 5 } 
                                                  ] } }
        assert_template 'schedules/edit'
        assert_select 'div[class=?]', 'alert alert-danger'
      end
    end
  end

  test "sucessful edit of schedules" do 
    assert_no_difference 'Schedule.count' do
      assert_difference 'Day.count', +1 do
        patch schedule_path(@schedule), params: { schedule: { name: "Lorem popsum", 
                                                              actor_transition_time: 45,
                                                              days_attributes: [ 
                                                              { start_time: Time.zone.parse('2016-04-08 7:00pm'), end_time: Time.zone.parse('2016-04-08 8:00pm'), _destroy: "1"},
                                                              { start_time: Time.now, end_time: Time.now + 5 } 
                                                  ] } }
        assert_redirected_to @schedule
        follow_redirect!
        assert !flash.empty?
        assert_select 'div[class=?]', 'alert alert-success'
      end
    end
  end

  test "sucessful deletion of a schedule" do
  	assert_difference 'Schedule.count', -1 do
  		assert_difference 'Day.count', -3 do
	      delete schedule_path(@schedule)
	      assert_redirected_to root_path
	      follow_redirect!
	      assert !flash.empty?
	      assert_select 'div[class=?]', 'alert alert-success'
  		end
  	end
  end

end
