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

  test "associated pieces should be null" do
    assert_no_difference 'Piece.count' do
    	@day1.destroy
    	assert_nil pieces(:manburns).day_id
    	assert_nil pieces(:stardust).day_id
    	assert_not_nil pieces(:sinner).day_id
    end
  end

  test "end time should be greater than start time" do
    @day1.end_time = Time.zone.parse('2016-04-08 7:00pm')
    assert_not @day1.valid?
  end

end
