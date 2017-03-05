require 'test_helper'

class ConflictsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @contact = contacts(:zach)
    @location = locations(:porter)
    @contact_conflict = conflicts(:conf1cont)
    @location_conflict = conflicts(:conf1loc)
  end

  test "should redirect create for contact when not logged in" do
    assert_no_difference 'Conflict.count' do
      post contact_conflicts_path @contact, params: { conflict: { description: "I hate conflicts", 
                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
    end
    assert_redirected_to login_url
  end

  test "should redirect index for contact when not logged in" do
    get contact_conflicts_path @contact
    assert_redirected_to login_url
    assert !flash.empty?
  end

  test "should redirect destroy for contact when not logged in" do
    assert_no_difference 'Conflict.count' do
      delete contact_conflict_path(@contact, @contact_conflict)
    end
    assert_redirected_to login_url
  end

  test "should not create contact conflicts for anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference '@contact.conflicts.count' do
      post contact_conflicts_path @contact, params: { conflict: { description: "I hate conflicts", 
                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
    end
  end

  test "should redirect destroy for contact when logged in as anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference 'Conflict.count' do
      delete contact_conflict_path(@contact, @contact_conflict)
    end
    assert_redirected_to root_url
  end

  test "successful access of contact conflicts with friendly forwarding" do
    get contact_conflicts_path @contact
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to contact_conflicts_path @contact
    assert_nil session[:forwarding_url]
  end

  test "should redirect create for location when not logged in" do
    assert_no_difference 'Conflict.count' do
      post location_conflicts_path @location, params: { conflict: { description: "I hate conflicts", 
                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
    end
    assert_redirected_to login_url
  end

  test "should redirect index for location when not logged in" do
    get contact_conflicts_path @location
    assert_redirected_to login_url
    assert !flash.empty?
  end

  test "should redirect destroy for location when not logged in" do
    assert_no_difference 'Conflict.count' do
      delete location_conflict_path(@location, @location_conflict)
    end
    assert_redirected_to login_url
  end

  test "should not create location conflicts for anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference '@location.conflicts.count' do
      post location_conflicts_path @location, params: { conflict: { description: "I hate conflicts", 
                                                                  start_time: Time.zone.parse('2016-04-08 7:00pm'), 
                                                                  end_time: Time.zone.parse('2016-04-08 9:00pm') } }
    end
  end

  test "should redirect destroy for location when logged in as anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference 'Conflict.count' do
      delete location_conflict_path(@location, @location_conflict)
    end
    assert_redirected_to root_url
  end

  test "successful access of location conflicts with friendly forwarding" do
    get location_conflicts_path @location
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to location_conflicts_path @location
    assert_nil session[:forwarding_url]
  end

end