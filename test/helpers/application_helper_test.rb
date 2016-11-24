require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    assert_equal full_title,         "Fringr"
    assert_equal full_title("Help"), "Help | Fringr"
  end

end