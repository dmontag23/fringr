require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  
	def setup
		@schedule = schedules(:fringe2016)
	end

  test "associated days should be destroyed" do
    assert_difference 'Day.count', -3 do
      @schedule.destroy
    end
  end

  test "associated pieces should be destroyed" do
    assert_difference 'Piece.count', -5 do
      @schedule.destroy
    end
  end

end
