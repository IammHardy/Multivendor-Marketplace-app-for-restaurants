class FoodsController < ApplicationController
  before_action :set_food, only: [ :show ]

def index
  if params[:category_id].present?
    @selected_category = Category.friendly.find(params[:category_id])
    @subcategories     = @selected_category.subcategories

    if params[:subcategory_id].present?
      @selected_subcategory = Category.friendly.find(params[:subcategory_id])
      @foods = @selected_subcategory.foods.includes(:reviews, :vendor)
    else
      @foods = @selected_category.foods.includes(:reviews, :vendor)
    end
  else
    @foods = Food.all.includes(:reviews, :vendor)
  end
end





  def show
    # @food is already set by set_food
    @vendor = Vendor.find(params[:vendor_id])
      @food = @vendor.foods.find(params[:id])
    @reviews = @food.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
    @review = @food.reviews.new
  end

  private

  def set_food
    @food = Food.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to foods_path, alert: "Food not found."
  end
end
