require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  def setup
		@location = locations(:porter)
    @piece = pieces(:manburns)
  end

  test "initial location should be valid" do
    assert @location.valid?
  end

  test "name should be present" do
    @location.name = "   "
    assert_not @location.valid?
  end

  test "name should not be too long" do
    @location.name = "a" * 151
    assert_not @location.valid?
  end

  test "user id should be present" do
    @location.user_id = nil
    assert_not @location.valid?
  end

  test "associated pieces should have null location" do
    assert_no_difference 'Piece.count' do
      @location.destroy
      assert_nil @piece.reload.location_id
    end
  end

  test "associated conflicts should be destroyed" do
    assert_difference 'Conflict.count', -3 do
      @location.destroy
    end
  end

end
