require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	def setup
		@base_title = "Ruby on Rails Tutorial Sample App"
	end

  test "should get new" do
    get :new
    assert_response :success
  end
end
