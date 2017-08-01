describe ScheduledTime do
	
	fixtures :scheduled_times

	before do
		@scheduledtime = scheduled_times(:manburnsday1)
	end

	context "#initial ScheduledTime" do
	  it "should be valid" do
	    expect(@scheduledtime).to be_valid
	  end

		it "should contain a piece_id" do
			@scheduledtime.piece_id = "    "
			expect(@scheduledtime).to_not be_valid
		end

		it "should contain an optional day_id" do
			@scheduledtime.day_id = "    "
			expect(@scheduledtime).to be_valid
		end

		it "should contain an optional start_time" do
			@scheduledtime.start_time = nil
			expect(@scheduledtime).to be_valid
		end
	end

	context "#start_time" do

	  #TODO: Add validations for datetimes
		# it "should be a datetime" do
		# 	@scheduledtime.start_time = "Hello there"
		# 	expect(@scheduledtime).to_not be_valid
		# end

		it "rejects datetime outside of scheduled range" do
			@scheduledtime.start_time = Time.zone.parse('2016-04-08 6:59pm')
			expect(@scheduledtime).to_not be_valid(:manually_schedule_piece)
			@scheduledtime.start_time = Time.zone.parse('2016-04-08 8:01pm')
			expect(@scheduledtime).to_not be_valid(:manually_schedule_piece)
		end

		it "accepts valid datetime within scheduled range" do
			@scheduledtime.start_time = Time.zone.parse('2016-04-08 7:00pm')
			expect(@scheduledtime).to be_valid(:manually_schedule_piece)
			@scheduledtime.start_time = Time.zone.parse('2016-04-08 8:00pm')
			expect(@scheduledtime).to be_valid(:manually_schedule_piece)
		end
	end

end