require 'test_helper'

class PiecesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @schedule = schedules(:fringe2016michael)
    @piece = pieces(:manburns)
  end

  test "should redirect new when not logged in" do
    get new_schedule_piece_path(@schedule)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', "alert alert-danger"
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                 location_id: 1, rating: 3 } }
      end
    end
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', "alert alert-danger"
  end

  test "should redirect edit when not logged in" do
    get edit_schedule_piece_path(@schedule, @piece)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect update when not logged in" do
    patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                     location_id: 1, rating: 3 } }
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect show when not logged in" do
    get schedule_piece_path(@schedule, @piece)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect manually schedule when not logged in" do
    get manually_schedule_schedule_piece_path(@schedule, @piece)
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect manually schedule piece when not logged in" do
    patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                          location_id: 1, mycount: 3, rating: 3 } }
    assert_redirected_to login_path
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        delete schedule_piece_path(@schedule, @piece)
      end
    end
    assert_redirected_to login_url
    follow_redirect!
    assert !flash.empty?
    assert_select 'div[class=?]', 'alert alert-danger'
    assert_no_difference 'Schedule.count' do
      assert_no_difference 'Participant.count' do
        log_in_as(@user)
        assert_redirected_to root_url
      end
    end
  end

  test "should redirect edit when logged in as other user" do
    log_in_as(@other_user)
    get edit_schedule_piece_path(@schedule, @piece)
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as other user" do
    log_in_as(@other_user)
    patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                     location_id: 1, rating: 3 } }
    assert_redirected_to root_path
  end

  test "should redirect show when logged in as other user" do
    log_in_as(@other_user)
    get schedule_piece_path(@schedule, @piece)
    assert_redirected_to root_path
  end

  test "should redirect manually schedule when logged in as other user" do
    log_in_as(@other_user)
    get manually_schedule_schedule_piece_path(@schedule, @piece)
    assert_redirected_to root_path
  end

  test "should redirect manually schedule piece when logged in as other user" do
    log_in_as(@other_user)
    patch manually_schedule_schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                          location_id: 1, mycount: 3, rating: 3 } }
    assert_redirected_to root_path
  end

  test "should redirect destroy when logged in as other user" do
    log_in_as(@other_user)
    assert_no_difference 'Schedule.count' do
      assert_no_difference 'Participant.count' do
        delete schedule_piece_path(@schedule, @piece)
      end
    end
    assert_redirected_to root_path
  end

  test "successful creation of piece with friendly forwarding" do
    get new_schedule_piece_path(@schedule)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to new_schedule_piece_path(@schedule)
    assert_nil session[:forwarding_url]
    assert_difference 'Piece.count', +1 do
      assert_difference 'Participant.count', +3 do
        assert_difference 'ScheduledTime.count', +1 do
          post schedule_pieces_path(@schedule), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                 location: locations(:porter), rating: 3, mycount: 1, contact_ids: [contacts(:zach).id, contacts(:elle).id, contacts(:andrew).id] } }
          assert_redirected_to @schedule
          follow_redirect!
          assert_template 'schedules/show'
          assert !flash.empty?
          assert_select 'div[class=?]', 'alert alert-success'
        end
      end
    end
  end

  test "successful editing of piece with friendly forwarding" do
    get edit_schedule_piece_path(@schedule, @piece)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_schedule_piece_path(@schedule, @piece)
    assert_nil session[:forwarding_url]
    assert_no_difference 'Piece.count' do
      assert_no_difference 'Participant.count' do
        assert_no_difference 'ScheduledTime.count' do
          patch schedule_piece_path(@schedule, @piece), params: { piece: { title: "Test", length: 30, setup: 15 , cleanup: 5, 
                                                                          location: locations(:porter), rating: 3, mycount: 2 } }
          assert_not_equal @piece.title, @piece.reload.title
          follow_redirect!
          assert_template 'schedules/show'
          assert !flash.empty?
          assert_select 'div[class=?]', 'alert alert-success'
        end
      end
    end
  end

end
