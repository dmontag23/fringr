require 'test_helper'

class PieceTest < ActiveSupport::TestCase

	def setup
		@manburns = pieces(:manburns)
		@manburns.participants.create!(contact: contacts(:zach))
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

	test "piece with no location should be valid" do
		assert pieces(:arthur).valid?
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

	test "piece with no day and start_time should be valid" do
		assert pieces(:etoiles).valid?
	end

	test "schedule_id should be present" do
		@manburns.schedule_id = nil
		assert_not @manburns.valid?
	end
  
  test "associated participants should be destroyed" do
    assert_difference 'Participant.count', -1 do
      assert_no_difference 'Contact.count' do
      	@manburns.destroy
      end
    end
  end
  
end
