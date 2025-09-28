class FoodsController < ApplicationController
  before_action :set_food, only: [:show]

  def index
    # Load main categories
    @main_categories = Category.where(parent_id: nil).order(:name)

    # Determine selected category
    if params[:category_id].present?
      @selected_category = Category.friendly.find(params[:category_id])
    else
      @selected_category = @main_categories.first
    end

    # Load subcategories of the selected category
    @subcategories = @selected_category.children

    # Determine selected subcategory
    if params[:subcategory_id].present?
      @selected_subcategory = @subcategories.friendly.find(params[:subcategory_id])
    else
      @selected_subcategory = @subcategories.first
    end

    # Load foods filtered by subcategory if present, else by category
    if @selected_subcategory.present?
      @foods = @selected_subcategory.foods.includes(:vendor, :reviews).order(created_at: :desc)
    else
      @foods = @selected_category.foods.includes(:vendor, :reviews).order(created_at: :desc)
    end
  end

 def show
  @food = Food.friendly.find(params[:id])
  @vendor = @food.vendor

  # Reviews
  @reviews = @food.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  @review  = @food.reviews.new

  # Optional: show other foods from the same vendor
  @other_foods_from_vendor = @vendor.foods.where.not(id: @food.id).limit(4)
end


  private

  def set_food
    @food = Food.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to foods_path, alert: "Food not found."
  end
end
