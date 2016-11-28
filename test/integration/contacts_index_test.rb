require 'test_helper'

class ContactsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @contact = @user.contacts.find_by(email: "zsmith@example.com")
    log_in_as @user
  end

  test "user contacts display" do
    get contacts_path
    assert_template 'contacts/index'
    assert_select 'title', full_title("Contacts")
    assert_match @user.contacts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    assert_select 'a[href=?]', root_path, text: "Back"
    items_per_page = 10
    assert_select 'input[value=?]', "Delete", count: items_per_page
    @user.contacts.paginate(page: 1, per_page: items_per_page).order('name ASC').each do |contact|
      assert_match contact.name, response.body
      assert_match contact.email, response.body
    end
  end

  test "sucessful deletion of contacts" do
    assert_difference 'Contact.count', -1 do
      delete contact_path(@contact)
      assert_template 'contacts/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end

  test "unsucessful addition of contacts" do 
    assert_no_difference 'Contact.count' do
      post contacts_path, params: { contact: { name: "   ", email: "dmonq"} }
      assert_template 'contacts/index'
      assert_select 'div[class=?]', 'alert alert-danger'
    end
  end

  test "sucessful addition of contacts" do 
    assert_difference 'Contact.count', +1 do
      post contacts_path, params: { contact: { name: "Lorem ipsem", email: "lorem@ipsem.com" } }
      assert_template 'contacts/index'
      assert !flash.empty?
      assert_select 'div[class=?]', 'alert alert-success'
    end
  end
end
