class LandingController < ApplicationController
  include Rails.application.routes.url_helpers

 def index
  # Categories
  @main_categories = Category.where(parent_id: nil).includes(:children)

  # Promotions
  @promotions = Promotion.active

  # ✅ Top vendors for the grid
  @top_vendors = Vendor.limit(6)

  # Testimonials
  @testimonials = Testimonial.with_attached_image.limit(3)

  # ✅ Filter dropdown data
  @foods   = Food.select(:id, :name).order(:name)
  @vendors = Vendor.approved.select(:id, :name).order(:name)


  @price_ranges = [
    { label: "₦0 - ₦1,000",   min: 0,    max: 1000 },
    { label: "₦1,001 - ₦3,000", min: 1001, max: 3000 },
    { label: "₦3,001 - ₦5,000", min: 3001, max: 5000 },
    { label: "₦5,000+",        min: 5000, max: nil }
  ]
end


  # ✅ Optional search action (can also be a separate controller)
  def search
    @results = Food.includes(:vendor)

    if params[:food_id].present?
      @results = @results.where(id: params[:food_id])
    end

    if params[:vendor_id].present?
      @results = @results.where(vendor_id: params[:vendor_id])
    end

    if params[:price_range].present?
      min, max = params[:price_range].split('-').map(&:to_i)
      @results = @results.where("price >= ?", min)
      @results = @results.where("price <= ?", max) if max > 0
    end
  end
end
