require 'test_helper'

class DayTest < ActiveSupport::TestCase

	def setup
		@day1 = days(:day1michael)
	end

  test "initial day should be valid" do
    assert @day1.valid?
  end

  test "start_date should be present" do
    @day1.start_date = nil
    assert_not @day1.valid?
  end

  test "end_date should be present" do
    @day1.end_date = nil
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

end
