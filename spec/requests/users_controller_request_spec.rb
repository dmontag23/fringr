describe UsersController do

	fixtures :users

	before do
  	@user = users(:michael)
	end

	context "#routes" do
	  it "should get new" do
	    get signup_path
	    expect(response.status).to be(200)
	    assert_select "title", full_title("Sign up")
	  end

	  it "should redirect destroy when not logged in" do
	    expect do
	      delete user_path(@user)
	    end.to_not change{ User.count }
	    expect(response).to redirect_to(login_url)
	    expect do
	    	log_in_as(@user)
	      expect(response).to redirect_to(root_url)
	    end.to_not change{ User.count }
	  end
	end

end