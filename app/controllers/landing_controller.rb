class LandingController < ApplicationController
  include Rails.application.routes.url_helpers
  
  def index
    # Fetch all main categories and their children
    @main_categories = Category.where(parent_id: nil).includes(:children)

    # Fetch top active vendors (limit to 8 for layout purposes)
    @top_vendors = Vendor.active.limit(8)


    # Fetch testimonials for the testimonial section
    @testimonials = Testimonial.with_attached_image.limit(3)
  end
end
