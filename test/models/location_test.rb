require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
		@location = @user.locations.build(name: "Porter")
  end

  test "initial location should be valid" do
    assert @location.valid?
  end

  test "user id should be present" do
    @location.user_id = nil
    assert_not @location.valid?
  end

  test "name should be present" do
    @location.name = "   "
    assert_not @location.valid?
  end

  test "name should not be too long" do
    @location.name = "a" * 151
    assert_not @location.valid?
  end

end
