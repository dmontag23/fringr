require 'test_helper'

class LocationsIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @location = locations(:porter)
    log_in_as @user
  end

  test "user locations display" do
    get locations_path
    assert_template 'locations/index'
    assert_select 'title', full_title("Locations")
    assert_match @user.locations.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    assert_select 'a[href=?]', root_path, text: "Back"
    items_per_page = 10
    @user.locations.paginate(page: 1, per_page: items_per_page).order('name ASC').each do |location|
      assert_match location.name, response.body
      assert_select 'a[href=?]', location_conflicts_path(location), text: "View Conflicts"
      assert_select 'a[href=?]', location_path(location), text: "Delete"
    end
  end

  test "unsucessful addition of locations" do 
    assert_no_difference 'Location.count' do
      post locations_path, params: { location: { name: "   " } }
      assert_template 'locations/index'
      assert_select 'div[class=?]', 'alert alert-danger'
    end
  end

  test "sucessful addition of locations" do 
    assert_difference 'Location.count', +1 do
      post locations_path, params: { location: { name: "Lorem ipsem" } }
      assert_template 'locations/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

  test "sucessful deletion of locations" do
    assert_difference 'Location.count', -1 do
      delete location_path(@location)
      assert_template 'locations/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

end
