class Vendor::DashboardController < Vendor::BaseController
  before_action :authenticate_vendor!
  before_action :check_approval

  def index
    @vendor = current_vendor
    @foods_count = current_vendor.foods.count
    # Total orders for this vendor (count distinct orders, not order_items)
      @pending_orders_count = current_vendor.orders.where(status: "pending").count

     # Filter orders that are paid
    paid_orders = current_vendor.orders.where(status: "paid")
    @orders_count = paid_orders.count
    # Vendor earnings (sum of earnings across all their order items)
    @earnings = paid_orders.joins(:order_items).sum('order_items.vendor_earnings')
    # Platform commission from this vendor's orders
    @commission = paid_orders.joins(:order_items).sum('order_items.platform_commission')
    # Recent orders (latest 5)
    @recent_orders = current_vendor.orders.includes(:order_items, :user).order(created_at: :desc).limit(5)
  end

  private

  def check_approval
    return if current_vendor.active?

    sign_out(current_vendor)
    redirect_to new_vendor_session_path, alert: "Your account is still pending approval. You will receive an email once approved."
  end
end
