require 'test_helper'

class SchedulesHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    @schedule = schedules(:fringe2016michael)
    @day = days(:day1michael)
    @piece = pieces(:arthur)
    @resource_monitor = Array.new(@schedule.days.count) { DayResourceMonitor.new(@user.locations, @user.contacts) }
    @schedule.pieces.each { |piece| piece.scheduled_times.each { |time| time.update_attributes(day: nil, start_time: nil) } }
    log_in_as @user
  end

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

  test "schedule all test pieces" do
    schedule_all_pieces
    piece_1 = pieces(:manburns).reload
    piece_2 = pieces(:stardust).reload
    piece_3 = pieces(:sinner).reload
    piece_4 = pieces(:etoiles).reload
    piece_5 = pieces(:arthur).reload
    assert_equal @day, piece_1.scheduled_times.second.day
    assert_equal @day.start_time, piece_1.scheduled_times.second.start_time
    assert_equal @schedule.days.second, piece_1.scheduled_times.first.day
    assert_equal @schedule.days.second.start_time + (80 * 60), piece_1.scheduled_times.first.start_time
    assert_equal @day, piece_2.scheduled_times.first.day
    assert_equal @day.start_time, piece_2.scheduled_times.first.start_time
    assert_equal @schedule.days.second, piece_3.scheduled_times.first.day
    assert_equal @schedule.days.second.start_time + (25 * 60), piece_3.scheduled_times.first.start_time
    assert_equal @schedule.days.second, piece_4.scheduled_times.first.day
    assert_equal @schedule.days.second.start_time, piece_4.scheduled_times.first.start_time
    assert_equal @day, piece_5.scheduled_times.first.day
    assert_equal @day.start_time + (15 * 60), piece_5.scheduled_times.first.start_time
  end

  test "run pass on 3 pieces to verify correct scheduling" do
    @pieces_left_to_schedule =  [pieces(:arthur), pieces(:manburns), pieces(:sinner)]
    run_pass
    piece_1 = pieces(:arthur).reload
    piece_2 = pieces(:manburns).reload
    piece_3 = pieces(:sinner).reload
    assert_equal @day, piece_1.scheduled_times.first.day
    assert_equal @day.start_time, piece_1.scheduled_times.first.start_time
    assert_equal @schedule.days.second, piece_2.scheduled_times.first.day
    assert_equal @schedule.days.second.start_time, piece_2.scheduled_times.first.start_time
    assert_equal @schedule.days.second, piece_3.scheduled_times.first.day
    assert_equal @schedule.days.second.start_time + (35 * 60), piece_3.scheduled_times.first.start_time
  end

  test "search day should return a valid piece" do
    @pieces_left_to_schedule = [@piece]
    assert_difference '@pieces_left_to_schedule.length', -1 do
      @resource_monitor[0].locations_schedules[@piece.location_id] = [[0, 20]]
      assert_equal @piece, search_day([0,5,10,15,20,25,30,35,40], @day, 0)
    end
  end

  test "search day should return nil when a piece cannot be scheduled within the given start times" do
    @pieces_left_to_schedule = [@piece]
    assert_no_difference '@pieces_left_to_schedule.length' do
      @resource_monitor[0].locations_schedules[@piece.location_id] = [[0, 40]]
      assert_nil search_day([0,5,10,15,20,25,30,35,40], @day, 0)
    end
  end

  test "select piece should return nil when there are no pieces left to schedule" do
    assert_nil select_piece(10, @day, 0, Array.new)
  end

  test "select piece should reject invalid pieces and recurse to accept a valid piece" do
    @resource_monitor[0].locations_schedules[1] = [[20, 45]]
    assert_equal @piece, select_piece(35, @day, 0, [pieces(:manburns), @piece, pieces(:etoiles)])
  end

  test "check piece should initially be valid" do
    setup_check_piece
    assert check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)
  end

  test "check piece should reject pieces that go past the end of the day" do
    setup_check_piece
    @interval_length_of_piece_check_piece = [50, 65]
    @extended_interval_check_piece = [45, 80]
    assert_not check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)
  end

  test "check piece should reject pieces that are already scheduled on the same day" do
    setup_check_piece
    @resource_monitor[0].scheduled_pieces.push @piece
    assert_not check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)
  end

  test "check piece should reject pieces that have a location conflict" do
    setup_check_piece
    @resource_monitor[0].locations_schedules[@piece.location_id] = [[0,25], [40,65], [85,110]]
    assert_not check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)
  end

  test "check piece should reject pieces that have a person conflict" do
    setup_check_piece
    @resource_monitor[0].people_schedules[@piece.participants.first.contact_id][1] = [80, 110]
    assert_not check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)
    @resource_monitor[0].people_schedules[@piece.participants.second.contact_id][0] = [10, 40]
    assert_not check_piece(@day, @day_index_check_piece, @interval_length_of_piece_check_piece, @extended_interval_check_piece, @piece)
  end

  test "schedule piece" do
    current_day_resource = @resource_monitor[0]
    assert_difference 'current_day_resource.scheduled_pieces.length', +1 do
      schedule_piece(40, @day, 0, [35, 70], @piece)
      assert @day, @piece.scheduled_times.first.day
      assert 40, @piece.scheduled_times.first.start_time
      assert current_day_resource.scheduled_pieces.include? @piece
      assert_equal [[35, 70]], current_day_resource.locations_schedules[@piece.location_id]
      assert_equal [[35, 85]], current_day_resource.people_schedules[@piece.participants.first.contact_id]
      assert_equal [[35, 85]], current_day_resource.people_schedules[@piece.participants.second.contact_id]
    end
  end

  test "score pieces correct sorting" do
    assert_equal pieces(:etoiles), score_pieces(15, @day, @schedule.pieces)
  end

  test "score piece early day" do
    start_time = 10
    assert_equal 12, score_piece(start_time, @day, @piece)
  end

  test "score piece arthur early-mid day" do
    start_time = 15
    assert_equal 15, score_piece(start_time, @day, @piece)
  end

  test "score piece arthur mid-late day" do
    start_time = 30
    assert_equal 13, score_piece(start_time, @day, @piece)
  end

  test "score piece arthur late day" do
    start_time = 45
    assert_equal 13, score_piece(start_time, @day, @piece)
  end

  test "calc original score 1 length score" do
    piece_chosen = pieces(:stardust)
    assert_equal 1, calc_original_score("length", piece_chosen)
  end

  test "calc original score 2 length score" do
    piece_chosen = @piece
    assert_equal 2, calc_original_score("length", piece_chosen)
  end

  test "calc original score 3 cleanup score" do
    piece_chosen = pieces(:manburns)
    assert_equal 3, calc_original_score("cleanup", piece_chosen)
  end

  test "calc original score 4 setup score" do
    piece_chosen = pieces(:stardust)
    assert_equal 4, calc_original_score("setup", piece_chosen)
  end
  
end