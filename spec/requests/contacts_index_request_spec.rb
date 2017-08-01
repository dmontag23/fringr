describe "Contacts Index" do

	fixtures :users, :contacts

	before do
    @user = users(:michael)
    @contact = contacts(:zach)
    log_in_as @user
	end

	context "#display" do
	  it "user contacts" do
	    get contacts_path
	    expect(response).to render_template('contacts/index')
	    assert_select 'title', full_title("Contacts")
	    expect(response.body).to include @user.contacts.count.to_s
	    assert_select 'div.pagination', count: 1
	    assert_select 'a[href=?]', root_path, text: "Back"
	    items_per_page = 10
	    @user.contacts.paginate(page: 1, per_page: items_per_page).order('name ASC').each do |contact|
	      expect(response.body).to include contact.name
	      expect(response.body).to include contact.email
	      assert_select 'a[href=?]', contact_conflicts_path(contact), text: "View Conflicts"
	      assert_select 'a[href=?]', contact_path(contact), text: "Delete"
	    end
	  end
	end

	context "#addition of contacts" do
	  it "should not add contacts" do 
	    expect do
	      post contacts_path, params: { contact: { name: "   ", email: "dmonq"} }
	      expect(response).to render_template('contacts/index')
	      assert_select 'div[class=?]', 'alert alert-danger'
	    end.to_not change{ Contact.count }
	  end

	  it "should add contacts" do 
	    expect do
	      post contacts_path, params: { contact: { name: "Lorem ipsem", email: "lorem@ipsem.com" } }
	      expect(response).to render_template('contacts/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Contact.count }.by(1)
	  end
	end

	context "#deletion of contacts" do
	  it "should delete contacts" do
	    expect do
	      delete contact_path(@contact)
	      expect(response).to render_template('contacts/index')
	      expect(flash.empty?).to be(false)
	      assert_select 'div[class=?]', 'alert alert-success'
	    end.to change{ Contact.count }.by(-1)
	  end
	end

end