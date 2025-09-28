class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    food = Food.find(params[:food_id])
    quantity = params[:quantity].to_i
    cart_item = @cart.cart_items.find_by(food_id: food.id)

    if params[:commit_type] == "Checkout"
      # Proceed to Checkout logic
      if cart_item
        # Item already in cart — don't increase quantity
        redirect_to checkout_path, notice: "Item already in cart. You can adjust quantity in your cart before checkout."
      else
        # Item not in cart — add it and redirect to checkout
        cart_item = @cart.cart_items.build(food: food, quantity: quantity)
        if cart_item.save
          redirect_to checkout_path, notice: "Item added to cart. Proceed to checkout."
        else
          redirect_back fallback_location: foods_path, alert: "Could not add item to cart."
        end
      end
    else
      # Regular Add to Cart logic
      if cart_item
        cart_item.quantity += quantity
      else
        cart_item = @cart.cart_items.build(food: food, quantity: quantity)
      end

      if cart_item.save
        redirect_back fallback_location: foods_path, notice: "Item added to cart."
      else
        redirect_back fallback_location: foods_path, alert: "Could not add item to cart."
      end
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
    if cart_item.update(quantity: params[:quantity])
      redirect_to cart_path, notice: "Item updated."
    else
      redirect_to cart_path, alert: "Could not update item."
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed."
  end

  private

  def set_cart
    @cart = current_cart
  end
end
