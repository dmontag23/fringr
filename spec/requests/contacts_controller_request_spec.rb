describe ContactsController do
	
	fixtures :users, :contacts

	before do
    @user = users(:michael)
    @other_user = users(:archer)
    @contact = contacts(:zach)
	end

	context "#create" do
	  it "should redirect when not logged in" do
	    expect do
	      post contacts_path, params: { contact: { name: "Laura Shultz", email: "lshu@example.com" } }
	    end.to_not change{ Contact.count }
			expect(response).to redirect_to(login_url)
	  end

	  it "should not create user contacts for anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      post contacts_path, params: { contact: { name: "Laura Shultz", email: "lshu@example.com" } }
			end.to_not change{ @user.contacts.count }
	  end
	end

	context "#index" do

	  it "should redirect when not logged in" do
	  	get contacts_path
			expect(response).to redirect_to(login_url)
			expect(flash.empty?).to be(false)
	  end

		it "should access of contacts with friendly forwarding" do
		    get contacts_path
				expect(response).to redirect_to(login_path)
		    log_in_as(@user)
				expect(response).to redirect_to(contacts_path)
		    expect(session[:forwarding_url]).to be_nil
		end
	end

	context "#destroy" do

	  it "should redirect when not logged in" do
	    expect do
	      delete contact_path(@contact)
	    end.to_not change{ Contact.count }
			expect(response).to redirect_to(login_url)
	  end

	  it "should redirect when logged in as anyone but current user" do
	    log_in_as(@other_user)
	    expect do
	      delete contact_path(@contact)
	    end.to_not change{ Contact.count }
			expect(response).to redirect_to(root_url)
	  end
	end

end