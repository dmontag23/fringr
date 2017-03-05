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

  # TODO: Add validations for datetimes
	# test "start time should be a datetime" do
	# 	@scheduledtime.start_time = "Hello there"
	# 	assert_not @scheduledtime.valid?
	# end

	test "start time accepts valid datetime" do
		@scheduledtime.start_time = Time.zone.now
		assert @scheduledtime.valid?
	end

end
