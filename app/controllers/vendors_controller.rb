class VendorsController < ApplicationController
  before_action :authenticate_vendor!, only: [ :edit, :update ]
  before_action :set_vendor, only: :show

  def index
    @vendors = Vendor.approved.includes(:foods) # Preload foods for efficiency
  end

  def show
    # Load all foods for this vendor, including categories (many-to-many)
    @foods = @vendor.foods.includes(:categories)

    # Filter foods by category if category_id is passed
    if params[:category_id].present?
      @foods = @foods.joins(:categories).where(categories: { id: params[:category_id] })
    end

    # Get unique categories that have foods for this vendor
    @categories = Category.joins(:foods)
                         .where(foods: { vendor_id: @vendor.id })
                         .distinct

    # Vendor reviews
    @average_rating = @vendor.vendor_reviews.average(:rating)&.round(1)
    @reviews_count  = @vendor.vendor_reviews.count
  end

  def edit
    @vendor = current_vendor
  end

  def update
    @vendor = current_vendor
    if @vendor.update(vendor_params)
      redirect_to root_path, notice: "Profile updated successfully."
    else
      render :edit
    end
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(
      :name,
      :profile_image,
      :banner_image,
      :bio,
      :phone,
      :whatsapp,
      :city,
      :business_type,
      :opening_hours
    )
  end
end
