describe "Schedules CRUD" do
	
	fixtures :users, :schedules

	before do
    @user = users(:michael)
    @schedule = schedules(:fringe2016michael)
    log_in_as @user
	end

	context "#create" do
	  it "display" do
	    get new_schedule_path
	    expect(response).to render_template('schedules/new')
	    assert_select 'title', full_title("New Schedule")
	    assert_select 'a[href=?]', root_path, text: "Cancel"
	    @schedule.days.each do
	      assert_select 'input[placeholder=?]', "Click to add time", count: 2
	    end
	  end

	  it "should not add a schedule" do 
	    expect do
        post schedules_path, params: { schedule: { name: "      ", 
                                                   actor_transition_time: 10,
                                                   days_attributes: [ 
                                                   	{ start_time: Time.now, end_time: Time.now + 5 },
                                                    { start_time: Time.now, end_time: Time.now + 5 } 
                                                  ] } }
        expect(response).to render_template('schedules/new')
        assert_select 'div[class=?]', 'alert alert-danger'
	    end.to change{ Schedule.count }.by(0) & change{ Day.count }.by(0)
	  end

	  it "should add a schedule" do 
	    expect do
	      post schedules_path, params: { schedule: { name: "Lorem Ipsum", 
                                                 actor_transition_time: 10,
                                                 days_attributes: [ 
                                                 	{ start_time: Time.now, end_time: Time.now + 5 },
                                                  { start_time: Time.now, end_time: Time.now + 5, _destroy: "1" },
                                                  { start_time: Time.now, end_time: Time.now + 5 } 
                                                ] } }
	      expect(response).to redirect_to(@user.schedules.find_by(name: "Lorem Ipsum"))
	      follow_redirect!
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Schedule.count }.by(1) & change{ Day.count }.by(2)
	  end
	end

	context "#edit" do
	  it "display" do
	    get edit_schedule_path(@schedule)
	    expect(response).to render_template('schedules/edit')
	    assert_select 'title', full_title("Edit Schedule")
	    assert_select 'a[href=?]', root_path, text: "Cancel"
	  end

	  it "should not edit a schedule" do 
	    expect do
        patch schedule_path(@schedule), params: { schedule: { name: "      ", 
                                                              actor_transition_time: 10,
                                                              days_attributes: [ 
                                                              { start_time: Time.now, end_time: Time.now + 5 },
                                                              { start_time: Time.now, end_time: Time.now + 5 } 
                                                  ] } }
        expect(response).to render_template('schedules/edit')
        assert_select 'div[class=?]', 'alert alert-danger'
	    end.to change{ Schedule.count }.by(0) & change{ Day.count }.by(0)
	  end

	  it "should edit a schedule" do 
			expect do
        patch schedule_path(@schedule), params: { schedule: { name: "Lorem popsum", 
                                                              actor_transition_time: 45,
                                                              days_attributes: [ 
                                                              { start_time: Time.zone.parse('2016-04-08 7:00pm'), end_time: Time.zone.parse('2016-04-08 8:00pm'), _destroy: "1"},
                                                              { start_time: Time.now, end_time: Time.now + 5 } 
                                                  ] } }
        expect(response).to redirect_to(@schedule)
        follow_redirect!
        expect(flash.empty?).to be(false)
        assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Schedule.count }.by(0) & change{ Day.count }.by(1)
	  end
	end

	context "#destroy" do
	  it "should delete a schedule" do
	  	expect do
	      delete schedule_path(@schedule)
      	expect(response).to redirect_to(root_path)
	      follow_redirect!
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	  	end.to change{ Schedule.count }.by(-1) & change{ Day.count }.by(-2)
	  end
	end

end