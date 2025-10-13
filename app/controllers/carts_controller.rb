# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
  @cart = current_cart

  respond_to do |format|
    format.html # full-page fallback
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "floating-cart-items",
        partial: "carts/cart_frame", # or cart_items
        locals: { cart: @cart }
      )
    end
  end
end



  def checkout
    @cart_items = current_cart.cart_items.includes(:food)
    @grand_total = @cart_items.sum { |item| item.food.price * item.quantity }
    # You can render a separate checkout view if you want
  end
end
