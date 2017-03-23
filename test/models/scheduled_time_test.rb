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

	test "start time rejects datetime outside of scheduled range" do
		@scheduledtime.start_time = Time.zone.parse('2016-04-08 6:59pm')
		assert_not @scheduledtime.valid?
		@scheduledtime.start_time = Time.zone.parse('2016-04-08 8:01pm')
		assert_not @scheduledtime.valid?
	end

	test "start time accepts valid datetime within scheduled range" do
		@scheduledtime.start_time = Time.zone.parse('2016-04-08 7:00pm')
		assert @scheduledtime.valid?
		@scheduledtime.start_time = Time.zone.parse('2016-04-08 8:00pm')
		assert @scheduledtime.valid?
	end

end
