# app/controllers/rider_dashboard/locations_controller.rb
module RiderDashboard
  class LocationsController < ApplicationController
    before_action :authenticate_rider!
    before_action :set_order

    def update
      if @order && current_rider
        current_rider.rider_locations.create(
          order_id: @order.id,
          latitude: params[:latitude],
          longitude: params[:longitude]
        )
        render json: { message: "Location updated" }
      else
        render json: { error: "Invalid order or rider" }, status: :unprocessable_entity
      end
    end

    private

    def set_order
      @order = Order.find_by(id: params[:order_id])
    end
  end
end
