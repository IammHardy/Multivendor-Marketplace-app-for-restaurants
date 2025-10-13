module Public
  class VendorsController < ApplicationController
    before_action :set_vendor, only: [:show]

    def index
      @vendors = Vendor.approved.includes(:foods)

      # ✅ Render partial (no layout) if this was triggered from a turbo-frame link
      if turbo_frame_request?
        render partial: "public/vendors/index", locals: { vendors: @vendors }, layout: false
      else
        render :index
      end
    end

    def show
      @foods = @vendor.foods.includes(:categories)
      @foods = @foods.joins(:categories).where(categories: { id: params[:category_id] }) if params[:category_id].present?
      @foods = @vendor.foods.where(active: true)
      @categories = Category.joins(:foods).where(foods: { vendor_id: @vendor.id }).distinct
      @average_rating = @vendor.vendor_reviews.average(:rating)&.round(1)
      @reviews_count  = @vendor.vendor_reviews.count

      # ✅ Render without layout if requested inside a turbo-frame
      render layout: false if turbo_frame_request?
    end

    private

    def set_vendor
      @vendor = Vendor.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to public_vendors_path, alert: "Vendor not found."
    end
  end
end
