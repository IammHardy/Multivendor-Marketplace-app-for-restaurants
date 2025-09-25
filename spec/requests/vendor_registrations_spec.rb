require 'rails_helper'

RSpec.describe "VendorRegistrations", type: :request do
  describe "GET /step1" do
    it "returns http success" do
      get "/vendor_registrations/step1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /step2" do
    it "returns http success" do
      get "/vendor_registrations/step2"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /step3" do
    it "returns http success" do
      get "/vendor_registrations/step3"
      expect(response).to have_http_status(:success)
    end
  end

end
