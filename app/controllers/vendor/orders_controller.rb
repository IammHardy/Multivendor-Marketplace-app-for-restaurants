# app/controllers/vendors/orders_controller.rb
class Vendor::OrdersController < Vendor::BaseController
  before_action :authenticate_vendor!  # ensure vendor is logged in
  before_action :set_order, only: [:show, :mark_as_shipped]

  def index
    @orders = Order.joins(:order_items)
                   .where(order_items: { vendor_id: current_vendor.id })
                   .distinct
                   .order(created_at: :desc)
                   .page(params[:page])
  end

  def show
    # Only include items for this vendor
    @vendor_items = @order.order_items.where(vendor: current_vendor)
    @vendor_total = @vendor_items.sum(&:vendor_earnings)
  end

  def mark_as_shipped
    # Optional: allow vendor to update order status for their part
    @order_items = @order.order_items.where(vendor: current_vendor)
    @order_items.update_all(status: "shipped")  # or your custom status logic

    redirect_to vendors_order_path(@order), notice: "Your items marked as shipped."
  end

  private

  def set_order
    @order = Order.find(params[:id])
    # Ensure the vendor actually has items in this order
    unless @order.order_items.exists?(vendor: current_vendor)
      redirect_to vendors_dashboard_path, alert: "You don't have access to this order."
    end
  end
end
