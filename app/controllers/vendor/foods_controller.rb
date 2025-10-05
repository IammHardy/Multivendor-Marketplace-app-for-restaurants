class Vendor::FoodsController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_food, only: [:edit, :update, :destroy]
   
  # GET /vendor/foods
  def index
    @foods = current_vendor.foods.includes(:categories)
    @foods = current_vendor.foods.page(params[:page]).per(8)
  end

    def change
  add_column :foods, :active, :boolean, default: false, null: false
end

def toggle_status
  @food = current_vendor.foods.friendly.find(params[:id])
  @food.update(active: !@food.active)
  redirect_to vendor_foods_path, notice: "Food status updated successfully."
end

def toggle_stock
  @food = current_vendor.foods.friendly.find(params[:id])
  @food.update(in_stock: !@food.in_stock)   # ✅ flips between true/false
  redirect_to vendor_foods_path, notice: "Food stock status updated successfully."
end




  # GET /vendor/foods/new
  def new
    @food = current_vendor.foods.build
  end

  # POST /vendor/foods
  def create
    @food = current_vendor.foods.build(food_params)
    if @food.save
      redirect_to vendor_foods_path, notice: "Food created successfully."
    else
      render :new
    end
  end

  # GET /vendor/foods/:id/edit
  def edit; end

  # PATCH/PUT /vendor/foods/:id
  def update
    if @food.update(food_params)
      redirect_to vendor_foods_path, notice: "Food updated successfully."
    else
      render :edit
    end
  end

  # DELETE /vendor/foods/:id
  def destroy
    @food.destroy
    redirect_to vendor_foods_path, notice: "Food deleted successfully."
  end

  private

  # Use Friendly ID and ensure the food belongs to the current_vendor
  def set_food
    @food = current_vendor.foods.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to vendor_foods_path, alert: "Food not found or you don't have permission."
  end

  def food_params
    params.require(:food).permit(:name, :description, :price, :image, :stock, category_ids: [])
  end
end
