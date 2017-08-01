describe ConflictsController do
	
	fixtures :users, :contacts, :locations, :conflicts

	before do
    @user = users(:michael)
    @other_user = users(:archer)
    @contact = contacts(:zach)
    @location = locations(:porter)
    @contact_conflict = conflicts(:conf1cont)
    @location_conflict = conflicts(:conf1loc)
	end

	context "#create" do 
	  it "should redirect create when not logged in" do
	    expect do
	      post contact_conflicts_path @contact, params: { conflict: { description: "I hate conflicts", 
	                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
	                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
	    end.to_not change{ Conflict.count }
		expect(response).to redirect_to(login_url)
	  end

	  it "should not create contact conflicts for anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      post contact_conflicts_path @contact, params: { conflict: { description: "I hate conflicts", 
	                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
	                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
	  	end.to_not change{ @contact.conflicts.count }
	  end

	  it "should redirect for location when not logged in" do
	    expect do
	      post location_conflicts_path @location, params: { conflict: { description: "I hate conflicts", 
	                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
	                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
	    end.to_not change{ Conflict.count }
			expect(response).to redirect_to(login_url)
	  end

	  it "should not create location conflicts for anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      post location_conflicts_path @location, params: { conflict: { description: "I hate conflicts", 
	                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
	                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
			end.to_not change{ @location.conflicts.count }
	  end
	end

	context "#index" do
	  it "should redirect for contact when not logged in" do
	    get contact_conflicts_path(@contact)
	    expect(response).to redirect_to(login_url)
			expect(flash.empty?).to be(false)
	  end

	  it "should redirect for location when not logged in" do
	    get contact_conflicts_path @location
	    expect(response).to redirect_to(login_url)
			expect(flash.empty?).to be(false)
	  end

	  it "should access of contact conflicts with friendly forwarding" do
	    get contact_conflicts_path @contact
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(contact_conflicts_path @contact)
	    expect(session[:forwarding_url]).to be_nil
		end


	  it "should access of location conflicts with friendly forwarding" do
	    get location_conflicts_path @location
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(location_conflicts_path @location)
	    expect(session[:forwarding_url]).to be_nil
		end
	end

	context "#destroy" do

	  it "should redirect for contact when not logged in" do
	    expect do
	      delete contact_conflict_path(@contact, @contact_conflict)
	    end.to_not change{ Conflict.count }
	    expect(response).to redirect_to(login_url)
	  end

	  it "should redirect for contact when logged in as anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      delete contact_conflict_path(@contact, @contact_conflict)
	    end.to_not change{ Conflict.count }
	    expect(response).to redirect_to(root_url)
	  end

	  it "should redirect for location when not logged in" do
	    expect do
	      delete location_conflict_path(@location, @location_conflict)
	    end.to_not change{ Conflict.count }
	    expect(response).to redirect_to(login_url)
	  end

	  it "should redirect for location when logged in as anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      delete location_conflict_path(@location, @location_conflict)
	    end.to_not change{ Conflict.count }
	    expect(response).to redirect_to(root_url)
	  end
	end

end