require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @contact = @user.contacts.find_by(email: "zsmith@example.com")
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Contact.count' do
      post contacts_path, params: { contact: { name: "Laura Shultz", email: "lshu@example.com" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
  	get contacts_path
    assert_redirected_to login_url
    assert !flash.empty?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Contact.count' do
      delete contact_path(@contact)
    end
    assert_redirected_to login_url
  end

  test "should not create user contacts for anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference '@user.contacts.count' do
      post contacts_path, params: { contact: { name: "Laura Shultz", email: "lshu@example.com" } }
    end
  end

  test "should redirect destroy when logged in as anyone but current user" do
    log_in_as(@other_user)
    assert_no_difference 'Contact.count' do
      delete contact_path(@contact)
    end
    assert_redirected_to root_url
  end

  test "successful access of contacts with friendly forwarding" do
    get contacts_path
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to contacts_path
    assert_nil session[:forwarding_url]
  end

end