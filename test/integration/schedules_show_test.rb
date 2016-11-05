require 'test_helper'

class SchedulesShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @schedule = @user.schedules.find_by(name: "Fringe 2016")
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
  
end
