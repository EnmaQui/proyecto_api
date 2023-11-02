require "test_helper"

class TodoControllerTest < ActionDispatch::IntegrationTest
  test "should get homepage" do
    get todo_homepage_url
    assert_response :success
  end
end
