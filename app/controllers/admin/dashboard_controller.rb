class Admin::DashboardController < Admin::BaseController
  def index
    # Summary Stats
    @total_vendors   = Vendor.count
    @active_vendors  = Vendor.active.count
    @pending_vendors = Vendor.pending_approval.count

    @total_users     = User.count
    @total_foods     = Food.count
    @tickets = SupportTicket.order(created_at: :desc)
    # Only use paid orders
    paid_orders = Order.where(status: "paid")
    @total_orders = paid_orders.count

    # Platform commission from paid order items
    @total_platform_commission = OrderItem.joins(:order)
                                          .where(orders: { status: "paid" })
                                          .sum(:platform_commission)

    @recent_vendors = Vendor.order(created_at: :desc).limit(5)
    @recent_orders  = Order.includes(:user)
                           .order(created_at: :desc)
                           .limit(10)

    # Vendor stats (only paid items)
    @vendor_stats = Vendor.includes(:order_items).map do |vendor|
      vendor_paid_items = vendor.order_items
                                .joins(:order)
                                .where(orders: { status: "paid" })

      {
        vendor: vendor,
        total_orders: vendor_paid_items.count,
        total_price: vendor_paid_items.sum("order_items.price * order_items.quantity"), # original item price
        total_earning: vendor_paid_items.sum(:vendor_earnings),
        total_commission: vendor_paid_items.sum(:platform_commission)
      }
    end  # <-- <--- this was missing

    # Trends (only paid orders)
    @orders_trend   = paid_orders.group_by_day(:created_at).count
    @earnings_trend = OrderItem.joins(:order)
                               .where(orders: { status: "paid" })
                               .group_by_day(:created_at)
                               .sum(:platform_commission)

    # 7-day trend data for sparklines
    @users_last_7_days = User.where("created_at >= ?", 6.days.ago)
                             .group_by_day(:created_at, last: 7)
                             .count
                             .values

    @vendors_last_7_days = Vendor.where("created_at >= ?", 6.days.ago)
                                 .group_by_day(:created_at, last: 7)
                                 .count
                                 .values

    @orders_last_7_days = Order.where("created_at >= ?", 6.days.ago)
                               .group_by_day(:created_at, last: 7)
                               .count
                               .values

    @revenue_last_7_days = Order.where("created_at >= ?", 6.days.ago)
                                .group_by_day(:created_at, last: 7)
                                .sum(:total_price)
                                .values

    # Recent orders (optional)
    @recent_orders = Order.includes(:user, :vendor).order(created_at: :desc).limit(5)
  end

  def show
    @ticket = SupportTicket.find(params[:id])
  end

  def update
    @ticket = SupportTicket.find(params[:id])
    if @ticket.update(ticket_params)
      redirect_to admin_support_ticket_path(@ticket), notice: "Ticket updated successfully."
    else
      render :show
    end
  end

  private

  def ticket_params
    params.require(:support_ticket).permit(:status, :body) # status: open, closed, etc.
  end
end
