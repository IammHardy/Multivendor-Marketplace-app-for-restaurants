# spec/requests/vendor_registrations_spec.rb
require 'rails_helper'

RSpec.describe "VendorRegistrations", type: :request do
  let(:vendor_attrs_step1) { attributes_for(:vendor) }

  # Helper to simulate step1 completion and set session
  def complete_step1
    post step1_create_vendor_registration_path, params: { vendor: vendor_attrs_step1 }
    vendor = Vendor.last
    # Set the session for subsequent requests
    cookies[:_session_id] = session.id # ensure session persists
    session[:vendor_id] = vendor.id
    vendor
  end

  describe "GET /step1" do
    it "renders step1 successfully" do
      get step1_vendor_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /step1_create" do
    it "creates a vendor and redirects to step2" do
      post step1_create_vendor_registration_path, params: { vendor: vendor_attrs_step1 }
      created_vendor = Vendor.last
      expect(session[:vendor_id]).to eq(created_vendor.id)
      expect(response).to redirect_to(step2_vendor_registration_path)
    end
  end

  context "steps 2-4 (requires session[:vendor_id])" do
    before do
      @current_vendor = complete_step1
    end

    %w[step2 step3 step4].each do |step|
      describe "GET /#{step}" do
        it "renders #{step} successfully" do
          get send("#{step}_vendor_registration_path")
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
