class LandingController < ApplicationController
  include Rails.application.routes.url_helpers

 def index
    # Main categories for homepage
    @main_categories = Category.where(parent_id: nil)


    # All foods (for search form or homepage display)
    @foods = Food.includes(:vendor).all

    # All vendors (for search form)
    @vendors = Vendor.all

    # Top vendors for homepage grid (limit as needed)
    @top_vendors = Vendor.limit(8) # you can adjust limit or scope

    # Price ranges for search filter
    @price_ranges = [
      { label: "₦0 - ₦500", min: 0, max: 500 },
      { label: "₦501 - ₦1000", min: 501, max: 1000 },
      { label: "₦1001 - ₦2000", min: 1001, max: 2000 },
      { label: "₦2001+", min: 2001, max: 0 } # max 0 means no upper limit
    ]

 
   @promotions = Promotion.includes(:vendor, :food).all




    # Optional: Testimonials
    @testimonials = Testimonial.where(approved: true).limit(3)
  end

#  def search
#   @results = Food.none # start empty

#   if params[:food_id].present? && params[:vendor_id].present? && params[:price_range].present?
#     @results = Food.includes(:vendor)

#     @results = @results.where(id: params[:food_id])
#     @results = @results.where(vendor_id: params[:vendor_id])

#     min, max = params[:price_range].split('-').map(&:to_i)
#     @results = @results.where("price >= ?", min)
#     @results = @results.where("price <= ?", max) if max > 0
#   end

#   @results = @results.to_a
# end

def search
  # start with no results by default
  @results = Food.none 

  # check if at least one filter is selected
  if params[:food_id].present? || params[:vendor_id].present? || params[:price_range].present?
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




end