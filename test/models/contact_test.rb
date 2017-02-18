require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  def setup
    @contact = contacts(:zach)
  end

  test "initial contact with name and email should be valid" do
    assert @contact.valid?
  end

  test "name should be present" do
    @contact.name = "     "
    assert_not @contact.valid?
  end

  test "email should be present" do
    @contact.email = "     "
    assert_not @contact.valid?
  end

  test "user id should be present" do
    @contact.user_id = nil
    assert_not @contact.valid?
  end

  test "name should not be too long" do
    @contact.name = "a" * 51
    assert_not @contact.valid?
  end

  test "email should not be too long" do
    @contact.email = "a" * 244 + "@example.com"
    assert_not @contact.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @contact.email = valid_address
      assert @contact.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @contact.email = invalid_address
      assert_not @contact.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_contact = @contact.dup
    duplicate_contact.email = @contact.email.upcase
    assert_not duplicate_contact.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @contact.email = mixed_case_email
    @contact.save
    assert_equal mixed_case_email.downcase, @contact.reload.email
  end

  test "associated participants should be destroyed" do
    assert_difference 'Participant.count', -1 do
      @contact.destroy
    end
  end

  test "associated pieces should not contain the contact" do
    piece = pieces(:manburns)
    assert_difference 'piece.contacts.count', -1 do
      @contact.destroy
    end
  end

  test "associated conflicts should be destroyed" do
    assert_difference 'Conflict.count', -2 do
      @contact.destroy
    end
  end

end
