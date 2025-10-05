require 'rails_helper'

RSpec.describe "Admin::Promotions", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/promotions/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/promotions/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/promotions/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/admin/promotions/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
