# app/controllers/rider/orders_controller.rb
module RiderDashboard
  class OrdersController < ApplicationController
    before_action :authenticate_rider!
    before_action :set_order, only: [:accept, :start, :complete]

    def accept
      @order.update!(delivery_status: :assigned, rider: current_rider)
      broadcast_status
      redirect_to rider_dashboard_path, notice: "Order accepted!"
    end

    def start
      @order.update!(delivery_status: :picked_up)
      broadcast_status
      redirect_to rider_dashboard_path, notice: "Delivery started!"
    end

    def complete
      @order.update!(delivery_status: :delivered, status: :completed)
      broadcast_status
      redirect_to rider_dashboard_path, notice: "Order delivered!"
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def broadcast_status
      OrderStatusChannel.broadcast_to(@order, {
        status: @order.delivery_status,
        rider_name: @order.rider&.name
      })
    end
  end
end
