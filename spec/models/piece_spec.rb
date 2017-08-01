describe Piece do
	
	fixtures :pieces

	before do
		@manburns = pieces(:manburns)
		@manburns.mycount = @manburns.scheduled_times.count
	end

	context "#initial piece" do
	  it "should be valid" do
	    expect(@manburns).to be_valid
	  end

		it "should contain title" do
			@manburns.title = "    "
			expect(@manburns).to_not be_valid
		end

		it "title should not be too long" do
			@manburns.title = "a"*151
			expect(@manburns).to_not be_valid
		end

		it "should contain a length" do
			@manburns.length = nil
			expect(@manburns).to_not be_valid
		end

		it "should not have a 0 or negative length" do
			@manburns.length = 0
			expect(@manburns).to_not be_valid
			@manburns.length = -5
			expect(@manburns).to_not be_valid
		end

		it "should contain setup" do
			@manburns.setup = nil
			expect(@manburns).to_not be_valid
		end

		it "should not have a setup that is 0 or negative" do
			@manburns.setup = 0
			expect(@manburns).to_not be_valid
			@manburns.setup = -5
			expect(@manburns).to_not be_valid
		end

		it "should contain cleanup" do
			@manburns.cleanup = nil
			expect(@manburns).to_not be_valid
		end

		it "should not have a 0 or negative cleanup" do
			@manburns.cleanup = 0
			expect(@manburns).to_not be_valid
			@manburns.cleanup = -5
			expect(@manburns).to_not be_valid
		end

		it "should have an optional location" do
			@manburns.location = nil
			expect(@manburns).to be_valid
		end

		it "should have a rating" do
			@manburns.rating = "  "
			expect(@manburns).to_not be_valid
		end

		it "should not contain invalid ratings" do
			@manburns.rating = 0
			expect(@manburns).to_not be_valid
			@manburns.rating = 5
			expect(@manburns).to_not be_valid
		end

		it "should contain valid ratings" do
			(1..4).each do |rating|
				@manburns.rating = rating
				expect(@manburns).to be_valid
			end
		end

		it "should contain a schedule_id" do
			@manburns.schedule_id = nil
			expect(@manburns).to_not be_valid
		end

		it "should contain at least 1 scheduled time" do 
	  	@manburns.scheduled_times.destroy_all
	  	expect(@manburns).to_not be_valid
		end
	end

	context "#associated elements" do

		it "associated scheduled times should be destroyed" do
			expect do
				@manburns.destroy
			end.to change{ Piece.count }.by(-1) & change{ ScheduledTime.count }.by(-2)
	  end
	  
	  it "associated participants should be destroyed" do
	  	expect do
	  		@manburns.destroy
	  	end.to change{ Participant.count }.by(-1) & change{ Contact.count }.by(0) & change{ ScheduledTime.count }.by(-2)
	  end
	end

end