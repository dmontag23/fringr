require 'test_helper'

class DayTest < ActiveSupport::TestCase

	def setup
		@day1 = days(:day1)
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
