describe Conflict do 
	
	fixtures :conflicts, :locations

	before do
		@conflict = conflicts(:conf1cont)
	end

	context "#initial conflict" do 
		it "with contact, start, and end time should be valid" do 
			expect(@conflict).to be_valid
		end
		
		it "with null contact and location is not valid" do
    	@conflict.contact = nil
    	expect(@conflict).to_not be_valid
  	end

  	it "with both contact and location is not valid" do
    	@conflict.location = locations(:porter)
    	expect(@conflict).to_not be_valid
  	end

	  it "description should be present" do
	    @conflict.description = nil
	    expect(@conflict).to_not be_valid
	  end

	  it "start_time should be present" do
	    @conflict.start_time = nil
	    expect(@conflict).to_not be_valid
	  end

	  it "end_time should be present" do
	    @conflict.end_time = nil
	    expect(@conflict).to_not be_valid
	  end

	  it "start time should be less than the end time" do
	  	@conflict.start_time = Time.zone.parse('2016-04-09 11:00pm')
	  	expect(@conflict).to_not be_valid
		end
	end
end