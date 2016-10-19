require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title("")
    assert_select "a[href=?]", root_path,    count: 2
    assert_select "a[href=?]", about_path,   count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", signup_path,  count: 1
    assert_select "a[href=?]", login_path,   count: 2
    get about_path
    assert_template 'static_pages/about'
    assert_select "title", full_title("About")
    get contact_path
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
    get login_path
    assert_template 'sessions/new'
    assert_select "title", full_title("Login")
  end
  
end
