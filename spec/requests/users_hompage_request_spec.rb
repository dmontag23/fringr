describe "Users Hompage" do
	
	fixtures :users

	before do
    @user = users(:michael)
	end

	context "#login" do
	  it "should be invalid" do
	    get login_path
	    expect(response).to render_template('sessions/new')
	    post login_path, params: { session: { email: "", password: "" } }
	    expect(response).to render_template('sessions/new')
	    expect(flash.empty?).to be(false)
	    get root_path
	    expect(flash.empty?).to be(true)
	  end

	  it "should be valid followed by logout" do
	    login_params = { params: { session: { email:    @user.email,
	                                          password: 'password' } } }
	    get login_path
	    @user.toggle!(:activated)
	    post login_path, login_params
	    expect(is_logged_in?).to be(false)
	    expect(response).to render_template('sessions/new')
	    expect(flash.empty?).to be(false)
	    @user.toggle!(:activated)
	    post login_path, login_params
	    expect(response).to redirect_to(root_url)
	    follow_redirect!
	    expect(response).to render_template('static_pages/home')
	    assert_select "a[href=?]", edit_password_reset_path(@user), count: 1
	    assert_select "a[href=?]", user_path(@user),                count: 1
	    assert_select "a[href=?]", logout_path,                     count: 1
	    assert_select "a[href=?]", new_schedule_path,               count: 1
	    assert_select "a[href=?]", contacts_path,                   count: 1
	    assert_select "a[href=?]", locations_path,                  count: 1
	    assert_select "a[href=?]", signup_path,                     count: 0
	    assert_select "a[href=?]", login_path,                      count: 0
	    assert_select 'div.pagination', count:1
	    @user.schedules.paginate(page: 1, per_page: 10).each do |schedule|
	      expect(response.body).to include schedule.name
	      assert_select "a[href=?]", schedule_path(schedule)
	      assert_select "a[href=?]", edit_schedule_path(schedule)
	      assert_select 'a', text: "Delete"
	    end
	    get login_path
	    expect(response).to redirect_to(root_path)
	    delete logout_path
	    expect(is_logged_in?).to be(false)
	    expect(response).to redirect_to(root_url)
	    delete logout_path      # Simulate a user clicking logout in a second window
	    follow_redirect!
	    expect(response).to render_template('static_pages/home')
	    assert_select "a[href=?]", login_path,       count: 2
	    assert_select "a[href=?]", signup_path,      count: 1
	    assert_select "a[href=?]", logout_path,      count: 0
	  end

	  it "should remember user" do
	    log_in_as(@user, remember_me: '1')
	    expect(cookies['remember_token']).to eq assigns(:user).remember_token
	  end

	  it "should not remember user" do
	    log_in_as(@user, remember_me: '0')
	    expect(cookies['remember_token']).to be_nil
	  end
	end

end