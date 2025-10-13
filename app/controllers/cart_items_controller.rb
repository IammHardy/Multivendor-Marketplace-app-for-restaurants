class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_cart_item, only: [:update, :destroy]
  include ActionView::RecordIdentifier

  # === CREATE ===
  def create
    food = Food.friendly.find(params[:food_id])

    if food.out_of_stock?
      redirect_back fallback_location: public_foods_path, alert: "Sorry, this food is currently out of stock." and return
    end

    # Handle vendor switch
    if @cart.vendor.present? && @cart.vendor != food.vendor
      if params[:confirm_vendor_switch] == "true"
        @cart.cart_items.destroy_all
        @cart.update(vendor: food.vendor)
      else
        return render turbo_stream: turbo_stream.replace(
          "modal",
          partial: "shared/vendor_switch_modal",
          locals: { food: food }
        )
      end
    end

    @cart.update(vendor: food.vendor) if @cart.vendor.nil?

    quantity = (params[:quantity].presence || 1).to_i
    cart_item = @cart.cart_items.find_or_initialize_by(food: food)
    cart_item.quantity = (cart_item.quantity || 0) + quantity
    cart_item.vendor_id ||= food.vendor_id

    if cart_item.save
      respond_to do |format|
        format.html { redirect_back fallback_location: public_foods_path, notice: "#{food.name} added to cart." }
        format.turbo_stream do
          render_cart_update
        end
      end
    else
      redirect_back fallback_location: public_foods_path, alert: "Unable to add item to cart."
    end
  end

  # === UPDATE ===
  def update
    if @cart_item.update(quantity: params[:cart_item][:quantity])
      respond_to do |format|
        format.html { redirect_to cart_path, notice: "Item updated." }
        format.turbo_stream { render_cart_update }
      end
    else
      redirect_to cart_path, alert: "Could not update item quantity."
    end
  end

  # === DESTROY ===
  def destroy
    @cart_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Item removed from cart." }
      format.turbo_stream { render_cart_update }
    end
  end

  private

  def set_cart
    @cart = current_cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find_by(id: params[:id])
    redirect_to cart_path, alert: "Item not found in your cart." unless @cart_item
  end

def render_cart_update
  streams = []

  # Replace the whole floating cart frame (items + total)
  streams << turbo_stream.replace("floating-cart-items", partial: "carts/cart_frame", locals: { cart: @cart })

  # Update cart counts/badges
  streams << turbo_stream.replace("cart-count-desktop", partial: "carts/cart_count", locals: { cart: @cart })
  streams << turbo_stream.replace("cart-count-mobile", partial: "carts/cart_count", locals: { cart: @cart })

  # Optional: update floating cart button if you have a separate partial
  if lookup_context.exists?("shared/_floating_cart_button")
    streams << turbo_stream.replace("floating-cart-button", partial: "shared/floating_cart_button", locals: { cart: @cart })
  end

  render turbo_stream: streams
end


end
