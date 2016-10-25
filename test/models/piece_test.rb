require 'test_helper'

class PieceTest < ActiveSupport::TestCase

	def setup
		@manburns = pieces(:manburns)
		@manburns.participants.create!(contact: contacts(:zach))
	end

	test "piece with no day should be valid" do
		assert pieces(:etoiles).valid?
	end

	test "piece with no location should be valid" do
		assert pieces(:arthur).valid?
	end
  
  test "associated participants should be destroyed" do
    assert_difference 'Participant.count', -1 do
      assert_no_difference 'Contact.count' do
      	@manburns.destroy
      end
    end
  end
  
end
