require "test_helper"

class GomesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get gomes_top_url
    assert_response :success
  end
end
