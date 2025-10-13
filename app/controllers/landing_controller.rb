class LandingController < ApplicationController
  def index
    @main_categories = Category.where(parent_id: nil)
    @foods = Food.includes(:vendor).all
    @vendors = Vendor.all
    @top_vendors = Vendor.limit(8)
    @price_ranges = [
      { label: "₦0 - ₦500", min: 0, max: 500 },
      { label: "₦501 - ₦1000", min: 501, max: 1000 },
      { label: "₦1001 - ₦2000", min: 1001, max: 2000 },
      { label: "₦2001+", min: 2001, max: 0 }
    ]
    @promotions = Promotion.includes(:vendor, :food).all
    @testimonials = Testimonial.where(approved: true).limit(3)

    # ✅ This line fixes your “Content missing” issue for Turbo frame requests
    render layout: layout_for_turbo
  end
end
