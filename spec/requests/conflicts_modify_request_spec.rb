describe "Conflicts Modify" do
	
	fixtures :users, :contacts, :locations, :conflicts

	before do
    @user = users(:michael)
    @contact = contacts(:zach)
    @location = locations(:porter)
    log_in_as @user
	end

	context "#dispay should show conflicts for" do
	  it "contacts" do
	    get contact_conflicts_path(@contact)
	    expect(response).to render_template('conflicts/index')
	    assert_select 'title', full_title("Conflicts")
	    expect(response.body).to include @contact.conflicts.count.to_s
	    assert_select 'a[href=?]', root_path, text: "Back"
	    items_per_page = 10
	    @contact.conflicts.order('start_time ASC').each do |conflict|
	      expect(response.body).to include conflict.description
	      expect(response.body).to include conflict.start_time.to_formatted_s(:short)
	      expect(response.body).to include conflict.end_time.to_formatted_s(:short)
	      assert_select 'a[href=?]', contact_conflict_path(@contact, conflict), text: "Delete"
	    end
	  end

	  it "locations" do
	    get location_conflicts_path(@location)
	    expect(response).to render_template('conflicts/index')
	    assert_select 'title', full_title("Conflicts")
	    expect(response.body).to include @location.conflicts.count.to_s
	    assert_select 'a[href=?]', root_path, text: "Back"
	    items_per_page = 10
	    @location.conflicts.order('start_time ASC').each do |conflict|
	      expect(response.body).to include conflict.description
	      expect(response.body).to include conflict.start_time.to_formatted_s(:short)
	      expect(response.body).to include conflict.end_time.to_formatted_s(:short)
	      assert_select 'a[href=?]', location_conflict_path(@location, conflict), text: "Delete"
	    end
	  end
	end

	context "#addion of conflicts" do
	  it "should not add conflicts for contacts" do 
	    expect do
	      post contact_conflicts_path(@contact), params: { conflict: { description: "   ", start_time: Time.zone.now, end_time: 1.hour.ago } }
	      expect(response).to render_template('conflicts/index')
	      assert_select 'div[class=?]', 'alert alert-danger'
	    end.to_not change{ Conflict.count }
	  end

	  it "should add conflicts for contacts" do 
	    expect do
	      post contact_conflicts_path(@contact), params: { conflict: { description: "Lorem ipsem", start_time: 1.hour.ago, end_time: Time.zone.now } }
	      expect(response).to render_template('conflicts/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Conflict.count }.by(1)
	  end

	  it "should not add conflicts for locations" do 
	    expect do
	      post location_conflicts_path(@location), params: { conflict: { description: "   ", start_time: Time.zone.now, end_time: 1.hour.ago } }
	      expect(response).to render_template('conflicts/index')
	      assert_select 'div[class=?]', 'alert alert-danger'
	    end.to_not change{ Conflict.count }
	  end

	  it "should add conflicts for locations" do 
	    expect do
	      post location_conflicts_path(@location), params: { conflict: { description: "Lorem ipsem", start_time: 1.hour.ago, end_time: Time.zone.now } }
	      expect(response).to render_template('conflicts/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Conflict.count }.by(1)
	  end
	end

	context "#deletion of conflicts" do
	  it "should delete conflicts for contacts" do
	    expect do
	      delete contact_conflict_path(@contact, conflicts(:conf1cont))
	      expect(response).to render_template('conflicts/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Conflict.count }.by(-1)
	  end

	  it "should delete conflicts for locations" do
	    expect do
	      delete location_conflict_path(@location, conflicts(:conf1loc))
	      expect(response).to render_template('conflicts/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Conflict.count }.by(-1)
	  end
	end

end