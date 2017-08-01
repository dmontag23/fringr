describe "Password Resets" do
	
	fixtures :users

	before do
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
    @other_user = users(:archer)
	end

	context "#password resets" do
	  it "via email" do
	    get new_password_reset_path
	    expect(response).to render_template('password_resets/new')
	    # Invalid email
	    post password_resets_path, params: { password_reset: { email: "" } }
	    expect(flash.empty?).to be(false)
	    expect(response).to render_template('password_resets/new')
	    # Valid email
	    post password_resets_path,
	         params: { password_reset: { email: @user.email } }
	    expect(@user.reset_digest).to_not eq @user.reload.reset_digest
	    expect(1).to eq ActionMailer::Base.deliveries.size
	    expect(flash.empty?).to be(false)
	    expect(response).to redirect_to(root_url)
	    # Password reset form
	    user = assigns(:user)
	    # Wrong email
	    get edit_password_reset_path(user.reset_token, email: "")
	    expect(response).to redirect_to(root_url)
	    # Inactive user
	    user.toggle!(:activated)
	    get edit_password_reset_path(user.reset_token, email: user.email)
	    expect(response).to redirect_to(root_url)
	    user.toggle!(:activated)
	    # Right email, wrong token
	    get edit_password_reset_path('wrong token', email: user.email)
	    expect(response).to redirect_to(root_url)
	    # Right email, right token
	    get edit_password_reset_path(user.reset_token, email: user.email)
	    expect(response).to render_template('password_resets/edit')
	    assert_select "title", full_title("Reset password")
	    assert_select "input[name=email][type=hidden][value=?]", user.email
	    # Invalid password & confirmation
	    patch password_reset_path(user.reset_token),
	          params: { email: user.email,
	                    user: { password:              "foobaz",
	                            password_confirmation: "barquux" } }
	    assert_select 'div.alert'
	    # Empty password
	    patch password_reset_path(user.reset_token),
	          params: { email: user.email,
	                    user: { password:              "",
	                            password_confirmation: "" } }
	    assert_select 'div.alert'
	    # Valid password & confirmation
	    patch password_reset_path(user.reset_token),
	          params: { email: user.email,
	                    user: { password:              "foobaz",
	                            password_confirmation: "foobaz" } }
	    expect(user.reload.reset_digest).to be_nil
	    expect(is_logged_in?).to be(true)
	    expect(flash.empty?).to be(false)
	    expect(response).to redirect_to(root_path)
	  end

	  it "via website" do
	    log_in_as(@user)
	    get edit_password_reset_path(@user)
	    expect(response).to render_template('password_resets/edit')
	    patch password_reset_path(@other_user, 
	          params: {  user: { password:              "foobar",
	                             password_confirmation: "foobar" } })
	    expect(response).to redirect_to(root_path)
	    patch password_reset_path(@user, 
	          params: {  user: { password:              "foobar",
	                             password_confirmation: "foobar" } })
	    expect(response).to redirect_to(root_path)
	    follow_redirect!
			expect(response).to render_template('static_pages/home')
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', 'alert alert-success'
	  end
	end

	context "#token" do
	  it "expired token" do
	    get new_password_reset_path
	    post password_resets_path,
	         params: { password_reset: { email: @user.email } }

	    @user = assigns(:user)
	    @user.update_attribute(:reset_sent_at, 3.hours.ago)
	    patch password_reset_path(@user.reset_token),
	          params: { email: @user.email,
	                    user: { password:              "foobar",
	                            password_confirmation: "foobar" } }
	    expect(response.status).to be(302)
	    follow_redirect!
	    expect(flash.empty?).to be(false)
	    assert_select 'div[class=?]', 'alert alert-danger'
	  end
	end

end