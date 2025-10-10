module RiderDashboard
class DashboardController < ApplicationController
  before_action :authenticate_rider!
  before_action :check_account_status

  def index
   # Only active orders: pending, assigned, picked_up
    @orders = current_rider.orders
                            .where(delivery_status: [:pending, :assigned, :picked_up])
                            .order(created_at: :desc)

  end

  private

  def check_account_status
    if current_rider.pending?
      redirect_to pending_rider_path, alert: "Your account is still pending approval."
    elsif current_rider.rejected?
      sign_out(current_rider)
      redirect_to new_rider_session_path, alert: "Your account has been rejected."
    elsif current_rider.suspended?
      sign_out(current_rider)
      redirect_to new_rider_session_path, alert: "Your account has been suspended."
    end
  end
end
end
