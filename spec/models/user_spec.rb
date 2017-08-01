describe User do
	
	fixtures :users

	before do
		@user = users(:archer)
		@user.password = "password"
	end

	context "#initial user" do
	  it "name and email should be valid" do
	    expect(@user).to be_valid
	  end

	  it "should contain a name" do
	    @user.name = "     "
	    expect(@user).to_not be_valid
	  end

	  it "should not contain a name that is too long" do
	    @user.name = "a" * 151
	    expect(@user).to_not be_valid
	  end

	  it "should contain a nonblank password" do
	    @user.password = @user.password_confirmation = " " * 6
	    expect(@user).to_not be_valid
	  end
	end

	context "#email" do

	  it "should exist" do
	    @user.email = "     "
	    expect(@user).to_not be_valid
	  end

	  it "should not be too long" do
	    @user.email = "a" * 244 + "@example.com"
	    expect(@user).to_not be_valid
	  end

	  it "should accept valid addresses" do
	    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
	                         first.last@foo.jp alice+bob@baz.cn]
	    valid_addresses.each do |valid_address|
	      @user.email = valid_address
	      expect(@user).to be_valid
	    end
	  end

	  it "should reject invalid addresses" do
	    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
	                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
	    invalid_addresses.each do |invalid_address|
	      @user.email = invalid_address
	      expect(@user).to_not be_valid, "#{invalid_address.inspect} should be invalid"
	    end
	  end

	  it "should be unique" do
	    duplicate_user = @user.dup
	    duplicate_user.email = @user.email.upcase
	    @user.save
	    expect(duplicate_user).to_not be_valid
	  end

	  it "should be saved as lower-case" do
	    mixed_case_email = "Foo@ExAMPle.CoM"
	    @user.email = mixed_case_email
	    @user.save
	    expect(mixed_case_email.downcase).to eq @user.reload.email
	  end
	end

	context "#authenticated?" do

	  it "should return false for a user with nil remember digest" do
	    expect(@user.authenticated?(:remember, '')).to be(false)
	  end

	  it "should return false for a user with nil activation digest" do
	    expect(@user.authenticated?(:activation, '')).to be(false)
	  end
	end

	context "#associated elements" do

	    it "associated schedules should be destroyed" do
	    expect do
	      @user.destroy
	    end.to change{ Schedule.count }.by(-1)
	  end

	  it "associated contacts should be destroyed" do
	    expect do
	      @user.destroy
	    end.to change{ Contact.count }.by(-1)
	  end

	  it "associated locations should be destroyed" do
	    expect do
	      @user.destroy
	    end.to change{ Location.count }.by(-1)
	  end
	end

end