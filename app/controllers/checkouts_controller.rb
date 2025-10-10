class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:food)
    @order = current_user.orders.build
  end

  def create
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:food)

    @order = current_user.orders.new(order_params)
    @order.status = "pending"
    @order.vendor = @cart_items.first.food.vendor if @cart_items.any? # ✅ Assign vendor

    if @order.save
      @cart_items.each do |item|
        @order.order_items.create!(
          food: item.food,
          vendor: item.food.vendor,
          quantity: item.quantity,
          subtotal: item.food.price * item.quantity
        )
      end

      # ✅ Save grand total correctly
      @order.update(total_price: @cart_items.sum { |item| item.subtotal })

      # ✅ Clear cart
      @cart_items.destroy_all

      redirect_to order_path(@order), notice: "Order placed successfully."
    else
      render :show
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :phone)
  end
end
