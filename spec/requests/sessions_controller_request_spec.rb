describe SessionsController do

	fixtures :users

	before do
		@user = users(:michael)
	end

	context "#new" do
	  it "should return ok if not logged in" do
	    get login_path
	    expect(response.status).to be(200)
			assert_select "title", full_title("Login")
	  end

	  it "should redirect to root path if logged in" do
	  	log_in_as(@user)
	    get login_path
	    expect(response).to redirect_to root_path
	    follow_redirect!
	    assert_select "title", full_title
	  end
	end

end