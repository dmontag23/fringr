require 'test_helper'

class SchedulesShowTest < ActionDispatch::IntegrationTest
  
  include SessionsHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = schedules(:fringe2016michael)
    @alt_schedule = schedules(:schedule_1)
    @piece = pieces(:manburns)
    log_in_as @user
  end

  test "schedule display" do
    get schedule_path(@alt_schedule)
    assert_template 'schedules/show'
    assert_select 'title', full_title("#{@alt_schedule.name}")
    assert_select 'a[href=?]', new_schedule_piece_path(@alt_schedule), count: 1
    assert_select 'a[href=?]', view_schedule_path(@alt_schedule),      count: 1
    assert_select 'a[href=?]', edit_schedule_path(@alt_schedule),      count: 1
    assert_select 'a[href=?]', contacts_path,                      count: 1
    assert_select 'a[href=?]', locations_path,                     count: 1
    assert_select 'div.pagination', count:1
    @alt_schedule.pieces.paginate(page: 1, per_page: 10).each do |piece|
      assert_match piece.title, response.body
      assert_select "a[href=?]", schedule_piece_path(@alt_schedule, piece)
      assert_select "a[href=?]", manually_schedule_schedule_piece_path(@alt_schedule, piece)
      assert_select "a[href=?]", edit_schedule_piece_path(@alt_schedule, piece)
      assert_select 'a', text: "Delete"
    end
  end

  test "new piece display" do
    get new_schedule_piece_path(@schedule)
    assert_template 'pieces/new'
    assert_select 'title', full_title("New Piece")
    assert_select 'a[href=?]', contacts_path, text: "Add Contact"
    assert_select 'a[href=?]', locations_path, text: "Add Location"
    assert_select 'a[href=?]', schedule_path(@schedule), text: "Cancel"
  end

  test "edit piece display" do
    get edit_schedule_piece_path(@schedule, @piece)
    assert_template 'pieces/edit'
    assert_select 'title', full_title("Edit Piece")
    assert_select 'a[href=?]', contacts_path, text: "Add Contact"
    assert_select 'a[href=?]', locations_path, text: "Add Location"
    assert_select 'a[href=?]', schedule_path(@schedule), text: "Cancel"
  end

  test "show piece display" do
    get schedule_piece_path(@schedule, @piece)
    assert_template 'pieces/show'
    assert_select 'title', full_title("#{@piece.title}")
    assert_select 'a[href=?]', schedule_path(@schedule), text: "Back"
  end

  test "view piece display" do
    get view_schedule_path(@schedule)
    assert_template 'schedules/view'
    assert_select 'title', full_title("Schedule for #{@schedule.name}")
    assert_select 'a[href=?]', schedule_path(@schedule), text: "Back"
  end

  test "manually schedule piece display" do
    get manually_schedule_schedule_piece_path(@schedule, @piece)
    assert_template 'pieces/manually_schedule'
    assert_select 'title', full_title("Manually Schedule #{@piece.title}")
    assert_select 'a[href=?]', previous_url, text: "Cancel"
  end

  test "unsucessful addition of a piece" do 
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        assert_no_difference 'ScheduledTime.count' do
          post schedule_pieces_path(@schedule), params: { piece: { title: "    ", length: 30, setup: 15 , cleanup: 5, 
                                                                       location: locations(:porter), rating: 3, contact_ids: [contacts(:zach).id, contacts(:andrew).id] } }
          assert_template 'pieces/new'
          assert_select 'div[class=?]', 'alert alert-danger'
        end
      end
    end
  end

  test "sucessful creation of a piece" do 
    assert_difference 'Piece.count', +1 do
      assert_difference 'Participant.count', +2 do
        assert_difference 'ScheduledTime.count', +3 do
          post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                       location: locations(:porter), rating: 3, mycount: 3, contact_ids: [contacts(:zach).id, contacts(:andrew).id] } }
          assert_redirected_to @schedule
          follow_redirect!
          assert !flash.empty?
          assert_select 'div[class=?]', 'alert alert-success'
        end
      end
    end
  end

  test "unsucessful edit of a piece" do 
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        assert_no_difference 'ScheduledTime.count' do
          patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: -30, setup: 15 , cleanup: 5, 
                                                                           location: locations(:porter), rating: 3 } }
          assert_template 'pieces/edit'
          assert_select 'div[class=?]', 'alert alert-danger'
        end
      end
    end
  end

  test "sucessful edit of a piece" do 
    assert_no_difference 'Piece.count' do
      assert_difference 'Participant.count', +2 do
        assert_difference 'ScheduledTime.count', +1 do
          patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                           location: locations(:porter), rating: 3, mycount: 3, contact_ids: [contacts(:zach).id, contacts(:andrew).id, contacts(:elle).id] } }
          assert_redirected_to @schedule
          follow_redirect!
          assert !flash.empty?
          assert_select 'div[class=?]', 'alert alert-success'
        end
      end
    end
  end

  test "unsucessful scheduling of pieces" do 
    log_in_as @other_user
    post view_schedule_path(schedules(:fringe2016archer))
    assert_template 'schedules/show'
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
    get root_path
    assert flash.empty?
  end

  test "sucessful deletion of a piece" do
    assert_difference 'Piece.count', -1 do
      assert_difference 'Participant.count', -1 do
        assert_difference 'ScheduledTime.count', -2 do
          delete schedule_piece_path(@schedule, @piece)
          assert_redirected_to @schedule
          follow_redirect!
          assert !flash.empty?
          assert_select 'div[class=?]', 'alert alert-success'
        end
      end
    end
  end

end