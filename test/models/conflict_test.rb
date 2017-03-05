require 'test_helper'

class ConflictTest < ActiveSupport::TestCase

	def setup
    @conflict = conflicts(:conf1cont)
  end

  test "initial conflict with contact, start, and end time should be valid" do
    assert @conflict.valid?
  end

  test "both contact and location cannot be null" do
    @conflict.contact = nil
    assert_not @conflict.valid?
  end

  test "both contact and location cannot be non-null" do
    @conflict.location = locations(:porter)
    assert_not @conflict.valid?
  end

  test "description should be present" do
    @conflict.description = nil
    assert_not @conflict.valid?
  end

  test "start_time should be present" do
    @conflict.start_time = nil
    assert_not @conflict.valid?
  end

  test "end_time should be present" do
    @conflict.end_time = nil
    assert_not @conflict.valid?
  end

  test "start time should be less than the end time" do
  	@conflict.start_time = Time.zone.parse('2016-04-09 11:00pm')
  	assert_not @conflict.valid?
	end

end
