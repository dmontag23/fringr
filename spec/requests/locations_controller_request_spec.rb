describe LocationsController do
	
	fixtures :users, :locations

	before do
    @user = users(:michael)
    @other_user = users(:archer)
    @location = locations(:porter)
	end

	context "#create" do
	  it "should redirect when not logged in" do
	    expect do
	      post locations_path, params: { location: { name: "Lorem ipsum" } }
	    end.to_not change{ Location.count }
			expect(response).to redirect_to(login_path)
	  end

	  it "should not create user locations for anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      post locations_path, params: { location: { name: "Lorem ipsum" } }
			end.to_not change{ @user.locations.count }
	  end
	end

	context "#index" do
	  it "should redirect when not logged in" do
	  	get locations_path
			expect(response).to redirect_to(login_path)
			expect(flash.empty?).to be(false)
		end

  	it "should access of locations with friendly forwarding" do
    	get locations_path
			expect(response).to redirect_to(login_path)
    	log_in_as(@user)
			expect(response).to redirect_to(locations_path)
    	expect(session[:forwarding_url]).to be_nil
		end
	end

	context "#destroy" do

	  it "should redirect when not logged in" do
	    expect do
	      delete location_path(@location)
	    end.to_not change{ Location.count }
			expect(response).to redirect_to(login_path)
	  end

	  it "should redirect when logged in as anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      delete location_path(@location)
	    end.to_not change{ Location.count }
			expect(response).to redirect_to(root_path)
	  end
	end

end