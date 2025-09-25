class Vendor::BaseController < ApplicationController
  before_action :authenticate_vendor!
  layout "vendor" # optional, if you want a separate layout

  def index
    # Vendor-specific dashboard logic
    @orders = current_vendor.order_items.includes(:order)
    @total_earnings = @orders.sum(:vendor_earnings)
    @total_orders = @orders.count

    # Group daily earnings for chart
    @daily_earnings = @orders.group("DATE(created_at)").sum(:vendor_earnings)
  end
end
