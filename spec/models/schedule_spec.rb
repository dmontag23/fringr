describe Schedule do
	
	fixtures :schedules

	before do
		@schedule = schedules(:fringe2016michael)
	end

	context "#initial schedule" do
	  it "should be valid" do
	    expect(@schedule).to be_valid
	  end

	  it "should contain a name" do
	    @schedule.name = "     "
	    expect(@schedule).to_not be_valid
	  end

	  it "should not contain a name that is too long" do
	    @schedule.name = "a"*151
	    expect(@schedule).to_not be_valid
	  end
	  
	  it "should contain actor_transition_time" do
	    @schedule.actor_transition_time = nil
	    expect(@schedule).to_not be_valid
	  end

	  it "should contain a user_id" do
	    @schedule.user_id = nil
	    expect(@schedule).to_not be_valid
	  end

	  it "should have at least 1 day" do
	    @schedule.days.destroy_all
	    expect(@schedule).to_not be_valid
	  end
	end

	context "#associated elements" do

	  it "associated days should be destroyed" do
	    expect do
	      @schedule.destroy
	    end.to change{ Day.count }.by(-2)
	  end

	  it "associated pieces should be destroyed" do
	    expect do
	      @schedule.destroy
	    end.to change{ Piece.count }.by(-5)
	  end
	end

end