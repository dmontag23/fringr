describe SchedulesController do
	
	fixtures :users, :schedules, :pieces

	before do
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = schedules(:fringe2016michael)
	end

	context "#new" do
	  it "should redirect when not logged in" do
	    get new_schedule_path
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end
	end

	context "#create" do
	  it "should redirect when not logged in" do
	    expect do
	      post schedules_path, params: { schedule: { name: "Lorem ipsum", 
	                                                 actor_transition_time: 35,
	                                                 days_attributes: [start_time: Time.now, 
	                                                                   end_time: Time.now + 5] } }
	    end.to_not change{ Schedule.count }
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should create schedule with friendly forwarding" do
	    get new_schedule_path
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(new_schedule_path)
	    expect(session[:forwarding_url]).to be_nil
	    expect do
        post schedules_path, params: { schedule: { name: "Lorem pipsum", 
                                                   actor_transition_time: 15,
                                                   days_attributes: [start_time: Time.now, 
                                                                     end_time: Time.now + 120] } }
        follow_redirect!
        expect(response).to render_template('schedules/show')
        expect(flash.empty?).to be(false)
        assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Schedule.count }.by(1) & change{ Day.count }.by(1)
	  end
	end

	context "#edit" do
	  it "should redirect when not logged in" do
	    get edit_schedule_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    get edit_schedule_path(@schedule)
	    expect(response).to redirect_to(root_path)
	  end

	  it "should edit schedule with friendly forwarding" do
	    get edit_schedule_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(edit_schedule_path(@schedule))
	    expect(session[:forwarding_url]).to be_nil
	    expect do
        patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
                                                              actor_transition_time: 45,
                                                              days_attributes: [start_time: Time.now, 
                                                                                end_time: Time.now + 120] } }
        expect(@schedule.name).to_not eq @schedule.reload.name
        follow_redirect!
        expect(response).to render_template('schedules/show')
        expect(flash.empty?).to be(false)
        assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Schedule.count }.by(0) & change{ Day.count }.by(1)
 	  end
	end

	context "#update" do
	  it "should redirect when not logged in" do
	    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
	                                                          actor_transition_time: 15,
	                                                          days_attributes: [start_time: Time.now, 
	                                                                 end_time: Time.now + 120] } }
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    patch schedule_path(@schedule), params: { schedule: { name: "Lorem pipsum", 
	                                                          actor_transition_time: 15,
	                                                          days_attributes: [start_time: Time.now, 
	                                                                 end_time: Time.now + 120] } }
	    expect(response).to redirect_to(root_path)
	  end
	end

	context "#show" do
	  it "should redirect when not logged in" do
	    get schedule_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    get schedule_path(@schedule)
	    expect(response).to redirect_to(root_path)
	  end
	end

	context "#view" do
	  it "should redirect when not logged in" do
	    get view_schedule_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    get view_schedule_path(@schedule)
	    expect(response).to redirect_to(root_path)
	  end
	end

	context "#schedule" do
	  it "should redirect when not logged in" do
	    post view_schedule_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    post view_schedule_path(@schedule)
	    expect(response).to redirect_to(root_path)
	  end

	  it "should not schedule pieces with null locations" do
	    pieces(:manburns).update_attribute(:location_id, nil)
	    log_in_as(@user)
	    post view_schedule_path(@schedule)
	    expect(response).to render_template('schedules/show')
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', 'alert alert-danger'
	    get root_path
	    expect(flash.empty?).to be(true)
	  end

	  it "should schedule pieces with no null locations" do
	    log_in_as(@user)
	    post view_schedule_path(@schedule)
	    expect(response).to redirect_to(view_schedule_path(@schedule))
	    follow_redirect!
	    expect(response).to render_template('schedules/view')
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', 'alert alert-success'
	    get root_path
	    expect(flash.empty?).to be(true)
	  end
	end

	context "#destroy" do
	  it "should redirect when not logged in" do
	    expect do
	      delete schedule_path(@schedule)
	    end.to_not change{ Schedule.count }
	    expect(response).to redirect_to(login_url)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	    expect do
	      log_in_as(@user)
	    expect(response).to redirect_to(root_url)
	    end.to_not change{ Schedule.count }
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    expect do
	      delete schedule_path(@schedule)
	    end.to_not change{ Schedule.count }
	    expect(response).to redirect_to(root_path)
	  end
	end

end