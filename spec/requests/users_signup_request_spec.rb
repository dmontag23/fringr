describe "Users Signup" do

	before do
    ActionMailer::Base.deliveries.clear
	end

	context "#signup" do
	  it "should be invalid" do
	    get signup_path
	    assert_select "form[action=?]", signup_path
	    expect do
	      post signup_path, params: { user: { name:  "",
	                                         	email: "user@invalid",
	                                         	password:              "foo",
	                                         	password_confirmation: "bar" } }
	    end.to_not change{ User.count }
	    expect(response).to render_template('users/new')
	    assert_select 'div.alert'
	    assert_select 'div.alert-danger'
	  end
	  
	  it "should be valid with account activation" do
	    get signup_path
	    expect do
	      post users_path, params: { user: { name:  "Example User",
	                                         email: "user@example.com",
	                                         password:              "password",
	                                         password_confirmation: "password" } }
	    end.to change{ User.count }.by(1)
	    expect(1).to eq ActionMailer::Base.deliveries.size
	    user = assigns(:user)
	    expect(user.activated?).to be(false)
	    # Try to log in before activation.
	    log_in_as(user)
	    expect(is_logged_in?).to be(false)
	    # Invalid activation token
	    get edit_account_activation_path("invalid token", email: user.email)
	    expect(is_logged_in?).to be(false)
	    # Valid token, wrong email
	    get edit_account_activation_path(user.activation_token, email: 'wrong')
	    expect(is_logged_in?).to be(false)
	    # Valid activation token
	    get edit_account_activation_path(user.activation_token, email: user.email)
	    expect(user.reload.activated?).to be(true)
	    follow_redirect!
	    expect(response).to render_template('static_pages/home')
	    expect(is_logged_in?).to be(true)
	  end
	end

end