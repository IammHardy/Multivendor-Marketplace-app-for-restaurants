# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = current_cart.cart_items.includes(:food)
    @grand_total = @cart_items.sum { |item| item.food.price * item.quantity }
  end

  def checkout
    @cart_items = current_cart.cart_items.includes(:food)
    @grand_total = @cart_items.sum { |item| item.food.price * item.quantity }
    # You can render a separate checkout view if you want
  end
end
