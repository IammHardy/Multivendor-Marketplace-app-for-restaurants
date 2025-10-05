require 'rails_helper'

RSpec.describe "Vendors::Promotions", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/vendors/promotions/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/vendors/promotions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/vendors/promotions/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/vendors/promotions/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/vendors/promotions/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/vendors/promotions/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
