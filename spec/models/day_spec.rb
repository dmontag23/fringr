describe Day do

	fixtures :days, :scheduled_times

	before do
		@day1 = days(:day1michael)
	end

	context "#initial day" do
	  it "should be valid" do
	    expect(@day1).to be_valid
	  end

	  it "should have a start_time" do
	    @day1.start_time = nil
	    expect(@day1).to_not be_valid
	  end

	  it "should have an end_time" do
	    @day1.end_time = nil
	    expect(@day1).to_not be_valid
	  end

	  it "should have a schedule_id" do
	    @day1.schedule_id = nil
	    expect(@day1).to_not be_valid
	  end

	  it "end time should be greater than start time" do
	    @day1.end_time = Time.zone.parse('2016-04-08 7:00pm')
	    expect(@day1).to_not be_valid
	  end

	  it "end time should not be 24 hours greater than start time" do
	    @day1.end_time = Time.zone.parse('2016-04-09 7:00pm')
	    expect(@day1).to_not be_valid
	  end
	end

	context "#associated elements" do

	  it "scheduled times should be null" do
	    expect do
	    	@day1.destroy
	    	expect(scheduled_times(:manburnsday1).day_id).to be_nil
	    	expect(scheduled_times(:stardustday1).day_id).to be_nil
	    	expect(scheduled_times(:sinnerday2).day_id).to_not be_nil
	    end.to_not change{ ScheduledTime.count }
	  end
	end

end