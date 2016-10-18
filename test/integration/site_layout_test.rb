require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title("")
    assert_select "a[href=?]", root_path,    count: 1
    assert_select "a[href=?]", about_path,   count: 1
    assert_select "a[href=?]", contact_path, count: 1
    get about_path
    assert_template 'static_pages/about'
    assert_select "title", full_title("About")
    get contact_path
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
  end
  
end
