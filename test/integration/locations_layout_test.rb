require 'test_helper'

class LocationLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @location = @user.locations.find_by(name: "Porter")
    log_in_as @user
  end

  test "user locations display" do
    get locations_path
    assert_template 'locations/index'
    assert_select 'title', full_title("Locations")
    assert_match @user.locations.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    items_per_page = 10
    assert_select 'input[value=?]', "Delete", count: items_per_page
    @user.locations.paginate(page: 1, per_page: items_per_page).order('name ASC').each do |location|
      assert_match location.name, response.body
    end
  end

  test "sucessful deletion of locations" do
    assert_difference 'Location.count', -1 do
      delete location_path(@location)
    end
  end

end
