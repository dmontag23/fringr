require 'test_helper'

class PieceTest < ActiveSupport::TestCase

	def setup
		@manburns = pieces(:manburns)
		@manburns.mycount = @manburns.scheduled_times.count
	end

  test "initial piece should be valid" do
    assert @manburns.valid?
  end

	test "title should be present" do
		@manburns.title = "    "
		assert_not @manburns.valid?
	end

	test "title should not be too long" do
		@manburns.title = "a"*151
		assert_not @manburns.valid?
	end

	test "length should be present" do
		@manburns.length = nil
		assert_not @manburns.valid?
	end

	test "length should not be 0 or negative" do
		@manburns.length = 0
		assert_not @manburns.valid?
		@manburns.length = -5
		assert_not @manburns.valid?
	end

	test "setup should be present" do
		@manburns.setup = nil
		assert_not @manburns.valid?
	end

	test "setup should not be 0 or negative" do
		@manburns.setup = 0
		assert_not @manburns.valid?
		@manburns.setup = -5
		assert_not @manburns.valid?
	end

	test "cleanup should be present" do
		@manburns.cleanup = nil
		assert_not @manburns.valid?
	end

	test "cleanup should not be 0 or negative" do
		@manburns.cleanup = 0
		assert_not @manburns.valid?
		@manburns.cleanup = -5
		assert_not @manburns.valid?
	end

	test "location should be optional" do
		@manburns.location = nil
		assert @manburns.valid?
	end

	test "rating should be present" do
		@manburns.rating = "  "
		assert_not @manburns.valid?
	end

	test "invalid ratings should be rejected" do
		@manburns.rating = 0
		assert_not @manburns.valid?
		@manburns.rating = 5
		assert_not @manburns.valid?
	end

	test "valid ratings should be accepted" do
		(1..4).each do |rating|
			@manburns.rating = rating
			assert @manburns.valid?
		end
	end

	test "schedule_id should be present" do
		@manburns.schedule_id = nil
		assert_not @manburns.valid?
	end

	test "associated scheduled times should be destroyed" do
    assert_difference 'ScheduledTime.count', -2 do
      assert_difference 'Piece.count', -1 do
      	@manburns.destroy
      end
    end
  end
  
  test "associated participants should be destroyed" do
    assert_difference 'Participant.count', -1 do
      assert_no_difference 'Contact.count' do
      	assert_difference 'ScheduledTime.count', -2 do
      		@manburns.destroy
      	end
      end
    end
  end

	test "pieces should contain at least 1 scheduled time" do 
  	@manburns.scheduled_times.destroy_all
  	assert_not @manburns.valid?
	end
  
end
