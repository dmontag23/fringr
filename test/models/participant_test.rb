require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  
  def setup
  	@participants = Participant.new(contact: contacts(:zach), piece: pieces(:manburns))
  end

  test "initial participants should be valid" do
    assert @participants.valid?
  end

  test "should require a contact" do
    @participants.contact = nil
    assert_not @participants.valid?
  end

  test "should require a piece" do
    @participants.piece = nil
    assert_not @participants.valid?
  end
end
