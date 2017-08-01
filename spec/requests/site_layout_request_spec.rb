describe "Site Layout" do
	
	context "# layout" do
	  it "links" do
	    get root_path
	    expect(response).to render_template('static_pages/home')
	    assert_select "title", full_title("")
	    assert_select "a[href=?]", root_path,       count: 2
	    assert_select "a[href=?]", about_path,      count: 1
	    assert_select "a[href=?]", contact_me_path, count: 1
	    assert_select "a[href=?]", signup_path,     count: 1
	    assert_select "a[href=?]", login_path,      count: 2
	    get about_path
	    expect(response).to render_template('static_pages/about')
	    assert_select "title", full_title("About")
	    get contact_me_path
	    expect(response).to render_template('static_pages/contact')
	    assert_select "title", full_title("Contact")
	    get signup_path
	    expect(response).to render_template('users/new')
	    assert_select "title", full_title("Sign up")
	    get login_path
	    expect(response).to render_template('sessions/new')
	    assert_select "title", full_title("Login")
	    assert_select "a[href=?]", password_resets_new_path, count: 1
	    assert_select "a[href=?]", signup_path,              count: 1
	    get password_resets_new_path
	    expect(response).to render_template('password_resets/new')
	    assert_select "title", full_title("Forgot password")
	  end
	end

end