require 'test_helper'

class ConflictsModifyTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @contact = contacts(:zach)
    @location = locations(:porter)
    log_in_as @user
  end

  test "conflicts display for contacts" do
    get contact_conflicts_path(@contact)
    assert_template 'conflicts/index'
    assert_select 'title', full_title("Conflicts")
    assert_match @contact.conflicts.count.to_s, response.body
    assert_select 'a[href=?]', root_path, text: "Back"
    items_per_page = 10
    @contact.conflicts.order('start_time ASC').each do |conflict|
      assert_match conflict.description, response.body
      assert_match conflict.start_time.to_formatted_s(:short), response.body
      assert_match conflict.end_time.to_formatted_s(:short), response.body
      assert_select 'a[href=?]', contact_conflict_path(@contact, conflict), text: "Delete"
    end
  end

  test "conflicts display for locations" do
    get location_conflicts_path(@location)
    assert_template 'conflicts/index'
    assert_select 'title', full_title("Conflicts")
    assert_match @location.conflicts.count.to_s, response.body
    assert_select 'a[href=?]', root_path, text: "Back"
    items_per_page = 10
    @location.conflicts.order('start_time ASC').each do |conflict|
      assert_match conflict.description, response.body
      assert_match conflict.start_time.to_formatted_s(:short), response.body
      assert_match conflict.end_time.to_formatted_s(:short), response.body
      assert_select 'a[href=?]', location_conflict_path(@location, conflict), text: "Delete"
    end
  end

  test "unsucessful addition of conflicts for contacts" do 
    assert_no_difference 'Conflict.count' do
      post contact_conflicts_path(@contact), params: { conflict: { description: "   ", start_time: Time.zone.now, end_time: 1.hour.ago } }
      assert_template 'conflicts/index'
      assert_select 'div[class=?]', 'alert alert-danger'
    end
  end

  test "unsucessful addition of conflicts for locations" do 
    assert_no_difference 'Conflict.count' do
      post location_conflicts_path(@location), params: { conflict: { description: "   ", start_time: Time.zone.now, end_time: 1.hour.ago } }
      assert_template 'conflicts/index'
      assert_select 'div[class=?]', 'alert alert-danger'
    end
  end

  test "sucessful addition of conflicts for contacts" do 
    assert_difference 'Conflict.count', +1 do
      post contact_conflicts_path(@contact), params: { conflict: { description: "Lorem ipsem", start_time: 1.hour.ago, end_time: Time.zone.now } }
      assert_template 'conflicts/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

  test "sucessful addition of conflicts for locations" do 
    assert_difference 'Conflict.count', +1 do
      post location_conflicts_path(@location), params: { conflict: { description: "Lorem ipsem", start_time: 1.hour.ago, end_time: Time.zone.now } }
      assert_template 'conflicts/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

  test "sucessful deletion of conflicts for contacts" do
    assert_difference 'Conflict.count', -1 do
      delete contact_conflict_path(@contact, conflicts(:conf1cont))
      assert_template 'conflicts/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

  test "sucessful deletion of conflicts for locations" do
    assert_difference 'Conflict.count', -1 do
      delete location_conflict_path(@location, conflicts(:conf1loc))
      assert_template 'conflicts/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

end