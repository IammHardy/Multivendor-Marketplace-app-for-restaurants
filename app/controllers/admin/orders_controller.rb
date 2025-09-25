# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < Admin::BaseController
  def index
   @orders = Order.includes(:user, :foods).order(created_at: :desc).page(params[:page]).per(10)

  end

  def update_status
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
      redirect_to admin_orders_path, notice: "Order status updated!"
    else
      redirect_to admin_orders_path, alert: "Failed to update order."
    end
  end
