describe Participant do 

	fixtures :contacts, :pieces

	before do
		@participants = Participant.new(contact: contacts(:zach), piece: pieces(:manburns))
	end

	context "#initial participant" do
	  it "should be valid" do
	    expect(@participants).to be_valid
	  end

	  it "should require a contact" do
	    @participants.contact = nil
	    expect(@participants).to_not be_valid
	  end

	  it "should require a piece" do
	    @participants.piece = nil
	    expect(@participants).to_not be_valid
	  end
	end

end