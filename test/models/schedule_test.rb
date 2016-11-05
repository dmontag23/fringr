require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  
	def setup
		@schedule = schedules(:fringe2016michael)
	end

  test "initial schedule should be valid" do
    assert @schedule.valid?
  end

  test "name should be present" do
    @schedule.name = "     "
    assert_not @schedule.valid?
  end

  test "name should not be too long" do
    @schedule.name = "a"*151
    assert_not @schedule.valid?
  end
  
  test "actor_transition_time should be present" do
    @schedule.actor_transition_time = nil
    assert_not @schedule.valid?
  end

  test "user_id should be present" do
    @schedule.user_id = nil
    assert_not @schedule.valid?
  end

  test "associated days should be destroyed" do
    assert_difference 'Day.count', -3 do
      @schedule.destroy
    end
  end

  test "associated pieces should be destroyed" do
    assert_difference 'Piece.count', -15 do
      @schedule.destroy
    end
  end

end
