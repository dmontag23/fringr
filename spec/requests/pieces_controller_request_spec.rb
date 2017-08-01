describe PiecesController do
	
	fixtures :users, :schedules, :pieces, :locations, :contacts, :scheduled_times

	before do
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = schedules(:fringe2016michael)
    @piece = pieces(:manburns)
	end

	context "#new" do
	  it "should redirect when not logged in" do
	    get new_schedule_piece_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end
	end

	context "#create" do
	  it "should redirect when not logged in" do
	    expect do
	      post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                               location_id: 1, rating: 3 } }
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should create piece with friendly forwarding" do
	    get new_schedule_piece_path(@schedule)
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(new_schedule_piece_path(@schedule))
	    expect(session[:forwarding_url]).to be_nil
	    expect do
	      post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                             location: locations(:porter), rating: 3, mycount: 1, contact_ids: [contacts(:zach).id, contacts(:elle).id, contacts(:andrew).id] } }
	    	expect(response).to redirect_to(@schedule)
	      follow_redirect!
	      expect(response).to render_template('schedules/show')
	    	expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Piece.count }.by(1) & change{ Participant.count }.by(3) & change{ ScheduledTime.count }.by(1)
	  end
	end

	context "#edit" do
	  it "should redirect when not logged in" do
	    get edit_schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    get edit_schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(root_path)
	  end

	  it "should edit piece with friendly forwarding" do
	    get edit_schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(edit_schedule_piece_path(@schedule, @piece))
	    expect(session[:forwarding_url]).to be_nil
	    expect do
	      patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                      location: locations(:porter), rating: 3, mycount: 2 } }
	      expect(@piece.title).to_not eq @piece.reload.title
	      follow_redirect!
	      expect(response).to render_template('schedules/show')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0) & change{ ScheduledTime.count }.by(0)
	  end
	end

	context "#update" do
	  it "should redirect when not logged in" do
	    patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                     location_id: 1, rating: 3 } }
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                     location_id: 1, rating: 3 } }
	    expect(response).to redirect_to(root_path)
	  end
	end

	context "#show" do
	  it "should redirect when not logged in" do
	    get schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    get schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(root_path)
	  end
	end

	context "#manually_schedule" do
	  it "should redirect when not logged in" do
	    get manually_schedule_schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    get manually_schedule_schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(root_path)
	  end
	end

	context "#manually_schedule_piece" do
	  it "should redirect when not logged in" do
	    patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                          location_id: 1, mycount: 3, rating: 3 } }
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                          location_id: 1, mycount: 3, rating: 3 } }
	    expect(response).to redirect_to(root_path)
	  end

	  it "should manually schedule piece with friendly forwarding" do
	    get manually_schedule_schedule_piece_path(@schedule, @piece)
	    expect(response).to redirect_to(login_path)
	    log_in_as(@user)
	    expect(response).to redirect_to(manually_schedule_schedule_piece_path(@schedule, @piece))
	    expect(session[:forwarding_url]).to be_nil
	    expect do
	      patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                      location: locations(:porter), rating: 3, mycount: 2, 
	                                                                      scheduled_times_attributes: [id: scheduled_times(:manburnsday1).id, 
	                                                                                                   start_time: Time.zone.parse('2016-04-08 7:10pm')] } }
	      expect(@piece.scheduled_times.first.start_time).to eq Time.zone.parse('2016-04-08 7:10pm')
	    	expect(response).to redirect_to(@schedule)
	      follow_redirect!
	      expect(response).to render_template('schedules/show')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0) & change{ ScheduledTime.count }.by(0)
	  end
	end

	context "#destroy" do
	  it "should redirect when not logged in" do
	    expect do
	      delete schedule_piece_path(@schedule, @piece)
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0)
	    expect(response).to redirect_to(login_path)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', "alert alert-danger"
	    expect do
        log_in_as(@user)
	    	expect(response).to redirect_to(root_url)
	    end.to change{ Schedule.count }.by(0) & change{ Participant.count }.by(0)
	  end

	  it "should redirect when logged in as other user" do
	    log_in_as(@other_user)
	    expect do
	      delete schedule_piece_path(@schedule, @piece)
	    end.to change{ Schedule.count }.by(0) & change{ Participant.count }.by(0)
	    expect(response).to redirect_to(root_path)
	  end
	end

end