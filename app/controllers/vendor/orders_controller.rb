# app/controllers/vendor/orders_controller.rb
class Vendor::OrdersController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :set_order, only: [:show, :mark_as_shipped]

  def index
    # Show ALL orders (pending + paid) so vendor can track them
    @orders = Order.joins(:order_items)
                   .where(order_items: { vendor_id: current_vendor.id })
                   .distinct
                   .order(created_at: :desc)
                   .page(params[:page])
  end

  def show
    # Only vendor's items in this order
    @vendor_items = @order.order_items.where(vendor: current_vendor)

    # Vendor should only earn from PAID orders
    if @order.status_paid?
      @vendor_total = @vendor_items.sum(&:vendor_earnings)
      @vendor_commission = @vendor_items.sum(&:platform_commission)
    else
      @vendor_total = 0
      @vendor_commission = 0
    end
  end

  def mark_as_shipped
    # Allow vendor to update only their items' status
    @order_items = @order.order_items.where(vendor: current_vendor)
    @order_items.update_all(status: "shipped")

    redirect_to vendor_order_path(@order), notice: "Your items have been marked as shipped."
  end

  private

  def set_order
    @order = Order.find(params[:id])
    unless @order.order_items.exists?(vendor: current_vendor)
      redirect_to vendor_dashboard_path, alert: "You don't have access to this order."
    end
  end
end
