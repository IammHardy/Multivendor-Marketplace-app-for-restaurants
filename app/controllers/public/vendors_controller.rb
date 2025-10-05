# app/controllers/public/vendors_controller.rb
module Public
  class VendorsController < ApplicationController
    before_action :set_vendor, only: [:show]

    def index
      @vendors = Vendor.approved.includes(:foods)
      
    end

    def show
      @foods = @vendor.foods.includes(:categories)
      if params[:category_id].present?
        @foods = @foods.joins(:categories).where(categories: { id: params[:category_id] })
      end
       @foods = @vendor.foods.where(active: true)
      @categories = Category.joins(:foods)
                            .where(foods: { vendor_id: @vendor.id })
                            .distinct

      @average_rating = @vendor.vendor_reviews.average(:rating)&.round(1)
      @reviews_count  = @vendor.vendor_reviews.count
    end

    private

    def set_vendor
      @vendor = Vendor.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to public_vendors_path, alert: "Vendor not found."
    end
  end
end
