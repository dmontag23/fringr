require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @location = @user.locations.find_by(name: "Porter")
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Location.count' do
      post locations_path, params: { location: { name: "Lorem ipsum" } }
    end
    assert_redirected_to login_path
  end

  test "should redirect index when not logged in" do
  	get locations_path
    assert_redirected_to login_path
    assert !flash.empty?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Location.count' do
      delete location_path(@location)
    end
    assert_redirected_to login_path
  end

  test "should not create user locations for anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference '@user.locations.count' do
      post locations_path, params: { location: { name: "Lorem ipsum" } }
    end
  end

  test "should redirect destroy when logged in as anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference 'Location.count' do
      delete location_path(@location)
    end
    assert_redirected_to root_path
  end

  test "successful access of locations with friendly forwarding" do
    get locations_path
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to locations_path
    assert_nil session[:forwarding_url]
  end

end
