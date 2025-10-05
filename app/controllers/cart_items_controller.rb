class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

 def create
  food = Food.friendly.find(params[:food_id])

  if food.out_of_stock?
    redirect_back fallback_location: public_foods_path, alert: "Sorry, this food is currently out of stock." and return
  end

  quantity = params[:quantity].to_i
  quantity = 1 if quantity <= 0

  cart_item = @cart.cart_items.find_or_initialize_by(food: food)
  cart_item.quantity = (cart_item.quantity || 0) + quantity
  cart_item.vendor_id ||= food.vendor_id

  if cart_item.save
    if params[:commit_type] == "Checkout"
      redirect_to checkout_path
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: public_foods_path, notice: "#{food.name} added to cart." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "floating_cart",
            partial: "shared/floating_cart",
            locals: { cart: @cart }
          )
        end
      end
    end
  else
    redirect_back fallback_location: public_foods_path, alert: cart_item.errors.full_messages.join(", ")
  end
end



  def update
  cart_item = @cart.cart_items.find(params[:id])
  quantity = params[:cart_item][:quantity].to_i
  quantity = 1 if quantity <= 0

  if cart_item.update(quantity: quantity)
    respond_to do |format|
      format.html { redirect_back fallback_location: checkout_path, notice: "Item updated." }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "checkout_cart_items",
          partial: "shared/checkout_cart_items",
          locals: { cart: @cart }
        )
      end
    end
  else
    redirect_back fallback_location: checkout_path, alert: "Could not update item."
  end
end

def destroy
  cart_item = @cart.cart_items.find(params[:id])
  cart_item.destroy
  respond_to do |format|
    format.html { redirect_back fallback_location: checkout_path, notice: "Item removed." }
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "checkout_cart_items",
        partial: "shared/checkout_cart_items",
        locals: { cart: @cart }
      )
    end
  end
end


  private

  def set_cart
    @cart = current_cart
  end
end
