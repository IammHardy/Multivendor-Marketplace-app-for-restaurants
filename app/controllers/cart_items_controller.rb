class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy, :show]

  # include this so `dom_id(@cart_item)` works inside the controller
  include ActionView::RecordIdentifier

  # === CREATE ===
  def create
    food = Food.friendly.find(params[:food_id])

    if food.out_of_stock?
      redirect_back fallback_location: public_foods_path, alert: "Sorry, this food is currently out of stock." and return
    end

    # --- Vendor switch handling ---
    if @cart.vendor.present? && @cart.vendor != food.vendor
      if params[:confirm_vendor_switch] == "true"
        @cart.cart_items.destroy_all
        @cart.update(vendor: food.vendor)
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "modal",
              partial: "shared/vendor_switch_modal",
              locals: { food: food }
            )
          end
        end
        return
      end
    end

    @cart.update(vendor: food.vendor) if @cart.vendor.nil?

    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0

    cart_item = @cart.cart_items.find_or_initialize_by(food: food)
    cart_item.quantity = (cart_item.quantity || 0) + quantity
    cart_item.vendor_id ||= food.vendor_id

    if cart_item.save
      respond_to do |format|
        format.html { redirect_back fallback_location: public_foods_path, notice: "#{food.name} added to cart." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("modal"),
            turbo_stream.replace(
              "floating_cart",
              partial: "shared/floating_cart",
              locals: { cart: @cart }
            ),
            turbo_stream.replace(
              "cart-count",
              partial: "carts/cart_count",
              locals: { cart: @cart }
            )
          ]
        end
      end
    else
      redirect_back fallback_location: public_foods_path, alert: "Unable to add item to cart."
    end
  end

  # === SHOW ===
def show
  @cart = current_cart
end



  # === UPDATE ===
  def update
    if @cart_item.update(quantity: params[:cart_item][:quantity])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "checkout_cart_items",
              partial: "carts/cart_items",
              locals: { cart: current_cart }
            ),
            turbo_stream.replace(
              "cart-count",
              partial: "carts/cart_count",
              locals: { cart: current_cart }
            )
          ]
        end
        format.html { redirect_to cart_path, notice: "Item updated." }
      end
    else
      redirect_to cart_path, alert: "Could not update item quantity."
    end
  end

  # === DESTROY ===
 def destroy
  @cart_item = current_cart.cart_items.find(params[:id])
  @cart_item.destroy

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.remove("cart_item_#{@cart_item.id}"),
        turbo_stream.replace("cart-count", partial: "carts/cart_count", locals: { cart: current_cart })
      ]
    end

    format.html { redirect_to cart_path, notice: "Item removed from cart." }
  end
end


  private

  def set_cart
    @cart = current_cart
  end

  def set_cart_item
    @cart_item = current_cart.cart_items.find_by(id: params[:id])
    redirect_to cart_path, alert: "Item not found in your cart." unless @cart_item
  end
end
