require 'test_helper'

class UsersHomepageTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    login_params = { params: { session: { email:    @user.email,
                                          password: 'password' } } }
    get login_path
    @user.toggle!(:activated)
    post login_path, login_params
    assert !is_logged_in?
    assert_template 'sessions/new'
    assert !flash.empty?
    @user.toggle!(:activated)
    post login_path, login_params
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", edit_password_reset_path(@user), count: 1
    assert_select "a[href=?]", user_path(@user),                count: 1
    assert_select "a[href=?]", logout_path,                     count: 1
    assert_select "a[href=?]", new_schedule_path,               count: 1
    assert_select "a[href=?]", contacts_path,                   count: 1
    assert_select "a[href=?]", locations_path,                  count: 1
    assert_select "a[href=?]", signup_path,                     count: 0
    assert_select "a[href=?]", login_path,                      count: 0
    assert_select 'div.pagination', count:2
    @user.schedules.paginate(page: 1, per_page: 10).each do |schedule|
      assert_match schedule.name, response.body
      assert_select "a[href=?]", schedule_path(schedule)
      assert_select "a[href=?]", edit_schedule_path(schedule)
      assert_select 'a', text: "Delete"
    end
    get login_path
    assert_redirected_to root_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path      # Simulate a user clicking logout in a second window
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path,       count: 2
    assert_select "a[href=?]", signup_path,      count: 1
    assert_select "a[href=?]", logout_path,      count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
