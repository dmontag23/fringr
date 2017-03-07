require 'test_helper'

class DayTest < ActiveSupport::TestCase

	def setup
		@day1 = days(:day1michael)
	end

  test "initial day should be valid" do
    assert @day1.valid?
  end

  test "start_time should be present" do
    @day1.start_time = nil
    assert_not @day1.valid?
  end

  test "end_time should be present" do
    @day1.end_time = nil
    assert_not @day1.valid?
  end

  test "schedule_id should be present" do
    @day1.schedule_id = nil
    assert_not @day1.valid?
  end

  test "associated scheduled times should be null" do
    assert_no_difference 'ScheduledTime.count' do
    	@day1.destroy
    	assert_nil scheduled_times(:manburnsday1).day_id
    	assert_nil scheduled_times(:stardustday1).day_id
    	assert_not_nil scheduled_times(:sinnerday2).day_id
    end
  end

  test "end time should be greater than start time" do
    @day1.end_time = Time.zone.parse('2016-04-08 7:00pm')
    assert_not @day1.valid?
  end

  test "end time should not be 24 hours greater than start time" do
    @day1.end_time = Time.zone.parse('2016-04-09 7:00pm')
    assert_not @day1.valid?
  end

end
