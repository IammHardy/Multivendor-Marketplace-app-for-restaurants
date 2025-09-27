# spec/requests/vendor/foods_spec.rb
require 'rails_helper'

RSpec.describe Vendor::FoodsController, type: :request do
  let(:vendor) { create(:vendor) } # or :user with vendor role
  let(:food) { create(:food) }

  before do
    sign_in vendor  # Devise helper method
  end

  describe "GET #index" do
    it "returns http success" do
      get vendor_foods_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get vendor_food_path(food)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new food" do
      expect {
        post vendor_foods_path, params: { food: { name: "Burger", price: 800 } }
      }.to change(Food, :count).by(1)
    end
  end
end
