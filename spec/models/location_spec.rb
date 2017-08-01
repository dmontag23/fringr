describe Location do
	
	fixtures :locations, :pieces

	before do
		@location = locations(:porter)
    @piece = pieces(:manburns)
	end

	context "#initial location" do
	  it "should be valid" do
	    expect(@location).to be_valid
	  end

	  it "should have a name" do
	    @location.name = "   "
	    expect(@location).to_not be_valid
	  end

	  it "should have a name that is not too long" do
	    @location.name = "a" * 151
	    expect(@location).to_not be_valid
	  end

	  it "should have a user id" do
	    @location.user_id = nil
	    expect(@location).to_not be_valid
	  end
	end

	context "#associated elements" do

	  it "associated pieces should have null location" do
	    expect do
	      @location.destroy
	      expect(@piece.reload.location_id).to be_nil
	    end.to_not change{ Piece.count }
	  end

	  it "associated conflicts should be destroyed" do
	    expect do
	      @location.destroy
	    end.to change { Conflict.count }.by(-3)
	  end
	end

end