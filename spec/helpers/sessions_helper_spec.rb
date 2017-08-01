describe SessionsHelper do

	fixtures :users

	before do
    @user = users(:michael)
    remember(@user)
	end
	
	context "#current_user" do
	  it "should return right user when session is nil" do
	    expect(@user).to eq current_user
	    expect(is_logged_in?).to be(true)
	  end

	  it "should return nil when remember digest is wrong" do
	    @user.update_attribute(:remember_digest, User.digest(User.new_token))
	    expect(current_user).to be_nil
	  end
	end

end