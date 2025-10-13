module Public
  class FoodsController < ApplicationController
    before_action :set_vendor, only: [:index]
    before_action :set_food, only: [:show]
    before_action :set_category, only: [:index]

    def index
      @subcategories = @selected_category&.subcategories || []

      if params[:subcategory_id].present?
        @selected_subcategory = Category.friendly.find(params[:subcategory_id])
        @foods = @selected_subcategory.foods.active
      elsif @selected_category.present?
        @selected_subcategory = @subcategories.first
        @foods = (@selected_subcategory || @selected_category).foods.active
      else
        @foods = Food.active
      end

      @foods = @foods.includes(:vendor, :reviews, :promotions)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(12)

      # Turbo frame requests only return the partial
      render layout: false if turbo_frame_request?
    end

    def show
      @vendor = @food.vendor
      @reviews = @food.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
      @review = @food.reviews.new
      @other_foods_from_vendor = @vendor.foods.where.not(id: @food.id).limit(4)

      respond_to do |format|
        format.html { render layout: !turbo_frame_request? }
      end
    end

    private

    def set_category
      @selected_category = Category.friendly.find(params[:category_id]) if params[:category_id].present?
    end

    def set_vendor
      @vendor = Vendor.friendly.find(params[:vendor_id]) if params[:vendor_id].present?
    end

    def set_food
      @food = Food.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to public_foods_path, alert: "Food not found."
    end
  end
end
