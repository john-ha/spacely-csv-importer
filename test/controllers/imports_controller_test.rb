require "test_helper"

class ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get imports_index_url
    assert_response :success
  end

  test "should get new" do
    get imports_new_url
    assert_response :success
  end

  test "should get show" do
    get imports_show_url
    assert_response :success
  end
end
