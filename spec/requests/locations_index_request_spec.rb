describe "Locations Index" do
	
	fixtures :users, :locations

	before do
    @user = users(:michael)
    @location = locations(:porter)
    log_in_as @user
	end

	context "#display" do
	  it "user locations" do
	    get locations_path
	    expect(response).to render_template('locations/index')
	    assert_select 'title', full_title("Locations")
	    expect(response.body).to include @user.locations.count.to_s
	    assert_select 'div.pagination', count: 1
	    assert_select 'a[href=?]', root_path, text: "Back"
	    items_per_page = 10
	    @user.locations.paginate(page: 1, per_page: items_per_page).order('name ASC').each do |location|
	      expect(response.body).to include location.name
	      assert_select 'a[href=?]', location_conflicts_path(location), text: "View Conflicts"
	      assert_select 'a[href=?]', location_path(location), text: "Delete"
	    end
	  end
	end

	context "#addition of locations" do
	  it "should not add locations" do 
	    expect do
	      post locations_path, params: { location: { name: "   " } }
	      expect(response).to render_template('locations/index')
	      assert_select 'div[class=?]', 'alert alert-danger'
	    end.to_not change{ Location.count }
	  end

	  it "should add locations" do 
	    expect do
	      post locations_path, params: { location: { name: "Lorem ipsem" } }
	      expect(response).to render_template('locations/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Location.count }.by(1)
	  end
	end

	context "#deletion of locations" do
	  it "should delete locations" do
	    expect do
	      delete location_path(@location)
	      expect(response).to render_template('locations/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Location.count }.by(-1)
	  end
	end

end