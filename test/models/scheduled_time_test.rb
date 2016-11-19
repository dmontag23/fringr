require 'test_helper'

class ScheduledTimeTest < ActiveSupport::TestCase
	
	def setup
		@scheduledtime = scheduled_times(:manburnsday1)
	end

  test "initial scheduled time should be valid" do
    assert @scheduledtime.valid?
  end

	test "piece id should be present" do
		@scheduledtime.piece_id = "    "
		assert_not @scheduledtime.valid?
	end

	test "optional day id" do
		@scheduledtime.day_id = "    "
		assert @scheduledtime.valid?
	end

	test "optional start time" do
		@scheduledtime.start_time = nil
		assert @scheduledtime.valid?
	end

	test "start time should be a number" do
		@scheduledtime.start_time = "Hello there"
		assert_not @scheduledtime.valid?
	end

	test "start time should not be negative" do
		@scheduledtime.start_time = -5
		assert_not @scheduledtime.valid?
	end

	test "start time accepts valid number" do
		@scheduledtime.start_time = 0
		assert @scheduledtime.valid?
	end

end
