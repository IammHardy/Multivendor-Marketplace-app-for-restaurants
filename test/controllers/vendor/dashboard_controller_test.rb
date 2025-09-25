require "test_helper"

class Vendor::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vendor_dashboard_index_url
    assert_response :success
  end
end
