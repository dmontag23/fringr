describe SchedulesHelper do
	
	fixtures :users, :schedules, :days, :pieces

	before do
    @user = users(:michael)
    @schedule = schedules(:fringe2016michael)
    @day = days(:day1michael)
    @piece = pieces(:arthur)
    @resource_monitor = Array.new#(@schedule.days.count) { DayResourceMonitor.new(@user.locations, @user.contacts) }
    @schedule.days.each do |day|
      @resource_monitor.push DayResourceMonitor.new(@user.locations, @user.contacts, day)
    end
    @schedule.pieces.each { |piece| piece.scheduled_times.each { |time| time.update_attributes(day: nil, start_time: nil) } }
    log_in_as_helpers @user
	end

	context "#schedule" do
		it "should schedule all test pieces" do
	    schedule_all_pieces
	    piece_1 = pieces(:manburns).reload
	    piece_2 = pieces(:stardust).reload
	    piece_3 = pieces(:sinner).reload
	    piece_4 = pieces(:etoiles).reload
	    piece_5 = pieces(:arthur).reload
	    expect(@day).to eq piece_1.scheduled_times.second.day
	    expect(@day.start_time).to eq piece_1.scheduled_times.second.start_time
	    expect(@schedule.days.second).to eq piece_1.scheduled_times.first.day
	    expect(@schedule.days.second.start_time + (80 * 60)).to eq piece_1.scheduled_times.first.start_time
	    expect(@day).to eq piece_2.scheduled_times.first.day
	    expect(@day.start_time).to eq piece_2.scheduled_times.first.start_time
	    expect(@schedule.days.second).to eq piece_3.scheduled_times.first.day
	    expect(@schedule.days.second.start_time + (25 * 60)).to eq piece_3.scheduled_times.first.start_time
	    expect(@schedule.days.second).to eq piece_4.scheduled_times.first.day
	    expect(@schedule.days.second.start_time).to eq piece_4.scheduled_times.first.start_time
	    expect(@day).to eq piece_5.scheduled_times.first.day
	    expect(@day.start_time + (15 * 60)).to eq piece_5.scheduled_times.first.start_time
		end

	  it "should run pass on 3 pieces to verify correct scheduling" do
	    @pieces_left_to_schedule =  [pieces(:arthur), pieces(:manburns), pieces(:sinner)]
	    run_pass
	    piece_1 = pieces(:arthur).reload
	    piece_2 = pieces(:manburns).reload
	    piece_3 = pieces(:sinner).reload
	    expect(@day).to eq piece_1.scheduled_times.first.day
	    expect(@day.start_time).to eq piece_1.scheduled_times.first.start_time
	    expect(@schedule.days.second).to eq piece_2.scheduled_times.first.day
	    expect(@schedule.days.second.start_time).to eq piece_2.scheduled_times.first.start_time
	    expect(@schedule.days.second).to eq piece_3.scheduled_times.first.day
	    expect(@schedule.days.second.start_time + (35 * 60)).to eq piece_3.scheduled_times.first.start_time
	  end
	end

	context "#search_day" do

	  it "should return a valid piece" do
	    @pieces_left_to_schedule = [@piece]
	    expect do
	      @resource_monitor[0].locations_schedules[@piece.location_id] = [[0, 20]]
	      expect(@piece).to eq search_day([0,5,10,15,20,25,30,35,40], @day, 0)
	    end.to change{ @pieces_left_to_schedule.length }.by(-1)
	  end

	  it "should return nil when a piece cannot be scheduled within the given start times" do
	    @pieces_left_to_schedule = [@piece]
	    expect do
	      @resource_monitor[0].locations_schedules[@piece.location_id] = [[0, 40]]
	      expect(search_day([0,5,10,15,20,25,30,35,40], @day, 0)).to be_nil
	    end.to_not change{ @pieces_left_to_schedule.length }
	  end
	end

	context "#select_piece" do

	  it "should return nil when there are no pieces left to schedule" do
	    expect(select_piece(10, @day, 0, Array.new)).to be_nil
	  end

	  it "should reject invalid pieces and recurse to accept a valid piece" do
	    @resource_monitor[0].locations_schedules[1] = [[20, 45]]
	    expect(@piece).to eq select_piece(35, @day, 0, [pieces(:manburns), @piece, pieces(:etoiles)])
	    expect(@day).to eq @piece.scheduled_times.first.day
	    expect(@day.start_time + (35 * 60)).to eq @piece.scheduled_times.first.start_time
	  end
	end

	context "#check_piece" do

	  it "should initially be valid" do
	    setup_check_piece
	    expect(check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)[:is_valid]).to be(true)
	  end

	  it "should reject pieces that go past the end of the day" do
	    setup_check_piece
	    @interval_length_of_piece_check_piece = [50, 65]
	    @extended_interval_check_piece = [45, 80]
	    expect(check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)[:is_valid]).to be(false)
	  end

	  it "should reject pieces that are already scheduled on the same day" do
	    setup_check_piece
	    @resource_monitor[0].scheduled_pieces.push @piece
	    expect(check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)[:is_valid]).to be(false)
	  end

	  it "should reject pieces that have a location conflict" do
	    setup_check_piece
	    @resource_monitor[0].locations_schedules[@piece.location_id] = [[0,25], [40,65], [85,110]]
	    expect(check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)[:is_valid]).to be(false)
	  end

	  it "should reject pieces that have a person conflict" do
	    setup_check_piece
	    @resource_monitor[0].people_schedules[@piece.participants.first.contact_id][1] = [80, 110]
	    expect(check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)[:is_valid]).to be(false)
	    @resource_monitor[0].people_schedules[@piece.participants.second.contact_id][0] = [10, 40]
	    expect(check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)[:is_valid]).to be(false)
	  end
	end

	context "#update_resource_monitor_for_scheduled_piece" do

	  it "should properly schedule a piece" do
	    current_day_resource = @resource_monitor[0]
	    expect do
	      update_resource_monitor_for_scheduled_piece(0, [35, 70], @piece)
	      expect(current_day_resource.scheduled_pieces.include? @piece).to be(true)
	      expect([[35, 70]]).to eq current_day_resource.locations_schedules[@piece.location_id]
	      expect([[35, 85]]).to eq current_day_resource.people_schedules[@piece.participants.first.contact_id]
	      expect([[35, 85]]).to eq current_day_resource.people_schedules[@piece.participants.second.contact_id]
	    end.to change{ current_day_resource.scheduled_pieces.length }.by(1)
	  end
	end

	context "#score_pieces" do

	  it "correct sorting" do
	    expect(pieces(:etoiles)).to eq score_pieces(15, @day, @schedule.pieces)
	  end

	  it  "early day" do
	    start_time = 10
	    expect(12).to eq score_piece(start_time, @day, @piece)
	  end

	  it "arthur early-mid day" do
	    start_time = 15
	    expect(15).to eq score_piece(start_time, @day, @piece)
	  end

	  it "arthur mid-late day" do
	    start_time = 30
	    expect(13).to eq score_piece(start_time, @day, @piece)
	  end

	  it "arthur late day" do
	    start_time = 45
	    expect(13).to eq score_piece(start_time, @day, @piece)
	  end
	end

	context "#calc_original_score" do

	  it "should be 1 length score" do
	    piece_chosen = pieces(:stardust)
	    expect(1).to eq calc_original_score("length", piece_chosen)
	  end

	  it "should be 2 length score" do
	    piece_chosen = @piece
	    expect(2).to eq calc_original_score("length", piece_chosen)
	  end

	  it "should be 3 cleanup score" do
	    piece_chosen = pieces(:manburns)
	    expect(3).to eq calc_original_score("cleanup", piece_chosen)
	  end

	  it "should be 4 setup score" do
	    piece_chosen = pieces(:stardust)
	    expect(4).to eq calc_original_score("setup", piece_chosen)
	  end
	end

	# helper methods
  def setup_check_piece
    @day_index_check_piece = 0
    @interval_length_of_piece_check_piece = [40, 55]
    @extended_interval_check_piece = [35, 70]
    @resource_monitor[0].locations_schedules[@piece.location_id] = [[0,35], [70,110]]
    @resource_monitor[0].people_schedules[@piece.participants.first.contact_id] = [[10,35], [85,110]]
    @resource_monitor[0].people_schedules[@piece.participants.second.contact_id] = [[10,35], [85,110]]
  end

  # for use in schedule all test pieces
  def current_user
    @user
  end

end