require 'support/sessions_helper'

describe "Schedules Show" do
	
	fixtures :users, :contacts, :locations, :schedules, :days, :pieces, :scheduled_times

	before do
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = schedules(:fringe2016michael)
    @alt_schedule = schedules(:schedule_1)
    @piece = pieces(:manburns)
    log_in_as @user
	end

	context "#show" do
	  it "display" do
	    get schedule_path(@alt_schedule)
	    expect(response).to render_template('schedules/show')
	    assert_select 'title', full_title("#{@alt_schedule.name}")
	    assert_select 'a[href=?]', new_schedule_piece_path(@alt_schedule), count: 1
	    assert_select 'a[href=?]', view_schedule_path(@alt_schedule),      count: 1
	    assert_select 'a[href=?]', edit_schedule_path(@alt_schedule),      count: 1
	    assert_select 'a[href=?]', contacts_path,                      count: 1
	    assert_select 'a[href=?]', locations_path,                     count: 1
	    assert_select 'div.pagination', count:1
	    @alt_schedule.pieces.paginate(page: 1, per_page: 10).each do |piece|
	      expect(response.body).to include piece.title
	      assert_select "a[href=?]", schedule_piece_path(@alt_schedule, piece)
	      assert_select "a[href=?]", manually_schedule_schedule_piece_path(@alt_schedule, piece)
	      assert_select "a[href=?]", edit_schedule_piece_path(@alt_schedule, piece)
	      assert_select 'a', text: "Delete"
	    end
	  end
	end

	context "#new piece" do
	  it "display" do
	    get new_schedule_piece_path(@schedule)
	    expect(response).to render_template('pieces/new')
	    assert_select 'title', full_title("New Piece")
	    assert_select 'a[href=?]', contacts_path, text: "Add Contact"
	    assert_select 'a[href=?]', locations_path, text: "Add Location"
	    assert_select 'a[href=?]', schedule_path(@schedule), text: "Cancel"
	  end

	  it "should not add a piece" do 
	    expect do
        post schedule_pieces_path(@schedule), params: { piece: { title: "    ", length: 30, setup: 15 , cleanup: 5, 
                                                                     location: locations(:porter), rating: 3, contact_ids: [contacts(:zach).id, contacts(:andrew).id] } }
        expect(response).to render_template('pieces/new')
        assert_select 'div[class=?]', 'alert alert-danger'
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0) & change{ ScheduledTime.count }.by(0)
	  end

	  it "should add a piece" do 
	    expect do
        post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                     location: locations(:porter), rating: 3, mycount: 3, contact_ids: [contacts(:zach).id, contacts(:andrew).id] } }
        expect(response).to redirect_to(@schedule)
        follow_redirect!
        expect(flash.empty?).to be(false)
        assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Piece.count }.by(1) & change{ Participant.count }.by(2) & change{ ScheduledTime.count }.by(3)
	  end
	end

	context "#edit piece" do
	  it "display" do
	    get edit_schedule_piece_path(@schedule, @piece)
	    expect(response).to render_template('pieces/edit')
	    assert_select 'title', full_title("Edit Piece")
	    assert_select 'a[href=?]', contacts_path, text: "Add Contact"
	    assert_select 'a[href=?]', locations_path, text: "Add Location"
	    assert_select 'a[href=?]', schedule_path(@schedule), text: "Cancel"
	  end

	  it "should not edit a piece" do 
	    expect do
        patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: -30, setup: 15 , cleanup: 5, 
                                                                         location: locations(:porter), rating: 3 } }
        expect(response).to render_template('pieces/edit')
        assert_select 'div[class=?]', 'alert alert-danger'
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0) & change{ ScheduledTime.count }.by(0)
	  end

	  it "should edit piece" do 
	    expect do
        patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                         location: locations(:porter), rating: 3, mycount: 3, contact_ids: [contacts(:zach).id, contacts(:andrew).id, contacts(:elle).id] } }
        expect(response).to redirect_to(@schedule)
        follow_redirect!
        expect(flash.empty?).to be(false)
        assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(2) & change{ ScheduledTime.count }.by(1)
	  end
	end

	context "#piece show" do
	  it "display" do
	    get schedule_piece_path(@schedule, @piece)
	    expect(response).to render_template('pieces/show')
	    assert_select 'title', full_title("#{@piece.title}")
	    assert_select 'a[href=?]', schedule_path(@schedule), text: "Back"
	  end
	end

	context "#view" do
	  it "view piece display" do
	    get view_schedule_path(@schedule)
	    expect(response).to render_template('schedules/view')
	    assert_select 'title', full_title("Schedule for #{@schedule.name}")
	    assert_select 'a[href=?]', schedule_path(@schedule), text: "Back"
	  end
	end

	context "#manually schedule piece" do
	  it "display" do
	    get manually_schedule_schedule_piece_path(@schedule, @piece)
	    expect(response).to render_template('pieces/manually_schedule')
	    assert_select 'title', full_title("Manually Schedule #{@piece.title}")
	    assert_select 'a[href=?]', previous_url, text: "Cancel"
	    @piece.scheduled_times.each do
	      assert_select 'input[placeholder=?]', "Click to add time"
	    end
	  end

	  it "should not manually schedule a piece" do
	    expect do
	      patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                                location: locations(:porter), rating: 3, mycount: 2, 
	                                                                                scheduled_times_attributes: [id: scheduled_times(:manburnsday1).id, 
	                                                                                                             start_time: Time.zone.parse('2016-04-08 9:10pm')] } }
	      expect(response).to render_template('pieces/manually_schedule')
	      assert_select 'div[class=?]', 'alert alert-danger'
	    end.to_not change{ ScheduledTime.count }
	  end

	  it "should manually scheduling a piece" do
	    expect do
	      patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                                location: locations(:porter), rating: 3, mycount: 2, 
	                                                                                scheduled_times_attributes: [id: scheduled_times(:manburnsday1).id,
	                                                                                                             start_time:""] } }
	      expect(response).to redirect_to(@schedule)
	      follow_redirect!
	      expect(response).to render_template('schedules/show')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	      get root_path
	      expect(flash.empty?).to be(true)
	      expect(@piece.scheduled_times.first.start_time).to be_nil
	      expect(@piece.scheduled_times.first.day).to be_nil
	      patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
	                                                                                location: locations(:porter), rating: 3, mycount: 2, 
	                                                                                scheduled_times_attributes: [id: scheduled_times(:manburnsday1).id,
	                                                                                                             start_time: Time.zone.parse('2016-04-08 7:18pm')] } }
	      expect(response).to redirect_to(@schedule)
	      follow_redirect!
	      expect(response).to render_template('schedules/show')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	      get root_path
	      expect(flash.empty?).to be(true)
	      expect(Time.zone.parse('2016-04-08 7:18pm')).to eq @piece.scheduled_times.first.start_time
	      expect(days(:day1michael)).to eq @piece.scheduled_times.first.day
	    end.to_not change{ ScheduledTime.count }
	  end
	end

	context "#schedule" do
	  it "should not schedule a piece" do 
	    log_in_as @other_user
	    post view_schedule_path(schedules(:fringe2016archer))
	    expect(response).to render_template('schedules/show')
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', 'alert alert-danger'
	    get root_path
	    expect(flash.empty?).to be(true)
	  end

	  it "should schedule a piece" do 
	    post view_schedule_path @schedule
	    post view_schedule_path(view_schedule_path @schedule)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', 'alert alert-success'
	    get root_path
	    expect(flash.empty?).to be(true)
	  end
	end

	context "#destroy" do
	  it "should not delete a piece" do
	    expect do
        log_in_as @other_user
        delete schedule_piece_path(@schedule, @piece)
        expect(response).to redirect_to(root_path)
	    end.to change{ Piece.count }.by(0) & change{ Participant.count }.by(0) & change{ ScheduledTime.count }.by(0)
	  end

	  it "should delete a piece" do
	    expect do
        delete schedule_piece_path(@schedule, @piece)
        expect(response).to redirect_to(@schedule)
        follow_redirect!
	    	expect(flash.empty?).to be(false)
        assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Piece.count }.by(-1) & change{ Participant.count }.by(-1) & change{ ScheduledTime.count }.by(-2)
	  end
	end

end