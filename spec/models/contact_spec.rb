describe Contact do
	
	fixtures :contacts, :pieces

	before do
    @contact = contacts(:zach)
    @other_contact = contacts(:zachh)
	end

	context "#initial contact" do 
	  it "with name and email should be valid" do
	    expect(@contact).to be_valid
	  end

	  it "should have a name" do
	    @contact.name = "     "
	    expect(@contact).to_not be_valid
	  end

	  it "should have a user id" do
	    @contact.user_id = nil
	    expect(@contact).to_not be_valid
	  end

	  it "should not contain a name that is too long" do
	    @contact.name = "a" * 51
	    expect(@contact).to_not be_valid
	  end
	end

	context "#email address" do
	  it "should be present" do
	    @contact.email = "     "
	    expect(@contact).to_not be_valid
	  end

	  it "should not be too long" do
	    @contact.email = "a" * 244 + "@example.com"
	    expect(@contact).to_not be_valid
	  end

	  it "accept valid" do
	    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
	                         first.last@foo.jp alice+bob@baz.cn]
	    valid_addresses.each do |valid_address|
	      @contact.email = valid_address
	      expect(@contact).to be_valid, "#{valid_address.inspect} should be valid"
	    end
	  end

	  it "reject invalid" do
	    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
	                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
	    invalid_addresses.each do |invalid_address|
	      @contact.email = invalid_address
	      expect(@contact).to_not be_valid, "#{invalid_address.inspect} should be invalid"
	    end
	  end

	  it "unique by user" do
	    duplicate_contact = @contact.dup
	    duplicate_contact.email = @contact.email.upcase
	    expect(duplicate_contact).to_not be_valid
	    expect(@other_contact).to be_valid
	  end

	  it "saved as lower-case" do
	    mixed_case_email = "Foo@ExAMPle.CoM"
	    @contact.email = mixed_case_email
	    @contact.save
	    expect(mixed_case_email.downcase).to eq @contact.reload.email
	  end
	end

	context "#associated elements" do
	  it "associated participants should be destroyed" do
	    expect do
	      @contact.destroy
	    end.to change{ Participant.count }.by(-1)
	  end

	  it "associated pieces should not contain the contact" do
	    piece = pieces(:manburns)
	    expect do
	      @contact.destroy
	    end.to change{ piece.contacts.count }.by(-1)
	  end

	  it "associated conflicts should be destroyed" do
	    expect do
	      @contact.destroy
	    end.to change{ Conflict.count }.by(-2)
	  end
	end

end