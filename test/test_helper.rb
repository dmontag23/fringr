ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# use minitest reporters (adds red to green bars in CLI when testing)
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Include all the helper functions found in the ApplicationHelper
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
end
