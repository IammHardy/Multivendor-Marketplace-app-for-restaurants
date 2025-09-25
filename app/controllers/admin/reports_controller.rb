class Admin::ReportsController < Admin::BaseController
  def index
    # Real data analytics
    @total_users = User.count
    @total_vendors = Vendor.count
    @total_orders = Order.count
    @revenue = Order.where(status: "paid").sum(:total_price)
    @recent_orders = Order.includes(:user, :vendor).order(created_at: :desc).limit(10)
  end
end
