module Public
  class FoodsController < ApplicationController
    before_action :set_vendor, only: [:index] # ❌ set_vendor is defined outside class
    before_action :set_food, only: [:show]
    before_action :set_category, only: [:index] # missing in your previous version

  def index
  @subcategories = @selected_category&.subcategories || []

  if params[:subcategory_id].present?
    @selected_subcategory = Category.friendly.find(params[:subcategory_id])
    @foods = @selected_subcategory.foods.where(active: true)
                                       .includes(:vendor, :reviews, :promotions)
                                       .order(created_at: :desc)
  elsif @selected_category.present?
    @selected_subcategory = @subcategories.first
    @foods = if @selected_subcategory
               @selected_subcategory.foods.where(active: true)
                                          .includes(:vendor, :reviews, :promotions)
                                          .order(created_at: :desc)
             else
               @selected_category.foods.where(active: true)
                                       .includes(:vendor, :reviews, :promotions)
                                       .order(created_at: :desc)
             end
  else
    @foods = Food.where(active: true)
                 .includes(:vendor, :reviews, :promotions)
                 .order(created_at: :desc)
  end

  @foods = @foods.page(params[:page]).per(12)
end



    def show
      @vendor = @food.vendor
      @reviews = @food.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
      @review = @food.reviews.new
      @other_foods_from_vendor = @vendor.foods.where.not(id: @food.id).limit(4)
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
