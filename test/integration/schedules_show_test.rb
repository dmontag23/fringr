require 'test_helper'

class SchedulesShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @schedule = @user.schedules.find_by(name: "Fringe 2016")
    @piece = pieces(:manburns)
    @piece.participants.create!(contact_id: 4)
    log_in_as @user
  end

  test "schedule display" do
    get schedule_path(@schedule)
    assert_template 'schedules/show'
    assert_select 'title', full_title("#{@schedule.name}")
    assert_select 'a[href=?]', new_schedule_piece_path(@schedule), count: 1
    assert_select 'a[href=?]', edit_schedule_path(@schedule),      count: 1
    assert_select 'a[href=?]', contacts_path,                      count: 1
    assert_select 'a[href=?]', locations_path,                     count: 1
    assert_select 'div.pagination', count:2
    @schedule.pieces.paginate(page: 1, per_page: 10).each do |piece|
      assert_match piece.title, response.body
      assert_select "a[href=?]", schedule_piece_path(@schedule, piece)
      assert_select "a[href=?]", edit_schedule_piece_path(@schedule, piece)
      assert_select 'a', text: "Delete"
    end
  end

  test "new piece display" do
    get new_schedule_piece_path(@schedule)
    assert_template 'pieces/new'
    assert_select 'title', full_title("New Piece")
  end

  test "edit piece display" do
    get edit_schedule_piece_path(@schedule, @piece)
    assert_template 'pieces/edit'
    assert_select 'title', full_title("Edit Piece")
  end

  test "show piece display" do
    get schedule_piece_path(@schedule, @piece)
    assert_template 'pieces/show'
    assert_select 'title', full_title("#{@piece.title}")
  end

  test "unsucessful addition of a piece" do 
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        post schedule_pieces_path(@schedule), params: { piece: { title: "    ", length: 30, setup: 15 , cleanup: 5, 
                                                                     location_id: 1, rating: 3, contact_ids: ["1", "3"] } }
        assert_template 'pieces/new'
        assert_select 'div[class=?]', 'alert alert-danger'
      end
    end
  end

  test "sucessful creation of a piece" do 
    assert_difference 'Piece.count', +1 do
      assert_difference 'Participant.count', +2 do
        post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                     location_id: 1, rating: 3, contact_ids: ["1", "3"] } }
        assert_redirected_to @schedule
        follow_redirect!
        assert !flash.empty?
        assert_select 'div[class=?]', 'alert alert-success'
      end
    end
  end

  test "unsucessful edit of a piece" do 
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: -30, setup: 15 , cleanup: 5, 
                                                                     location_id: 1, rating: 3 } }
        assert_template 'pieces/edit'
        assert_select 'div[class=?]', 'alert alert-danger'
      end
    end
  end

  test "sucessful edit of a piece" do 
    assert_no_difference 'Piece.count' do
      assert_difference 'Participant.count', +2 do
        patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                     location_id: 1, rating: 3, contact_ids: ["1", "3", "2"] } }
        assert_redirected_to @schedule
        follow_redirect!
        assert !flash.empty?
        assert_select 'div[class=?]', 'alert alert-success'
      end
    end
  end

  test "sucessful deletion of a schedule" do
    assert_difference 'Piece.count', -1 do
      assert_difference 'Participant.count', -1 do
        delete schedule_piece_path(@schedule, @piece)
        assert_redirected_to @schedule
        follow_redirect!
        assert !flash.empty?
        assert_select 'div[class=?]', 'alert alert-success'
      end
    end
  end
  
end
