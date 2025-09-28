class Vendor::FoodsController < Vendor::BaseController
  before_action :set_food, only: [ :show, :edit, :update, :destroy ]

  def index
    @foods = current_vendor.foods.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @food = current_vendor.foods.new
    @categories = Category.all
  end

  def create
    @food = current_vendor.foods.new(food_params)
    if @food.save
      redirect_to vendor_foods_path, notice: "Food created successfully!"
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @food.update(food_params)
      redirect_to vendor_foods_path, notice: "Food updated successfully!"
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @food = current_vendor.foods.friendly.find(params[:id])
  @food.destroy

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to vendor_foods_path, alert: "Food deleted successfully!" }
  end
end


  private

  def set_food
    @food = current_vendor.foods.friendly.find(params[:id])
  end

  def food_params
    params.require(:food).permit(:name, :description, :price, :image, category_ids: [])
  end
end
