class Admin::DashboardController < Admin::BaseController
  def index
    @total_vendors   = Vendor.count
    @active_vendors  = Vendor.active.count
    @pending_vendors = Vendor.pending_approval.count

    @total_users     = User.count
    @total_foods     = Food.count
    @total_orders    = Order.count
    @total_platform_commission = OrderItem.sum(:platform_commission)

    @recent_vendors  = Vendor.order(created_at: :desc).limit(5)
    @recent_orders   = Order.includes(:user).order(created_at: :desc).limit(10)

    # Vendor-specific stats for admin
    @vendor_stats = Vendor.includes(:order_items).map do |vendor|
      total_earning = vendor.order_items.sum(:vendor_earnings)
      total_commission = vendor.order_items.sum(:platform_commission)
      total_orders = vendor.order_items.count
      {
        vendor: vendor,
        total_orders: total_orders,
        total_earning: total_earning,
        total_commission: total_commission
      }
    end

    # Charts
    @orders_trend   = Order.group_by_day(:created_at).count
    @earnings_trend = OrderItem.group_by_day(:created_at).sum(:platform_commission) # total commission trend
  end
end
