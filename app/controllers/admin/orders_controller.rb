# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < Admin::BaseController
   def index
    @orders = Order.includes(:user, order_items: { food: :vendor }).all
  end

   

def show
  @order = Order.includes(order_items: { food: :vendor }, user: {}).find(params[:id])
end

def update_status
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
      redirect_to admin_orders_path, notice: "Order status updated!"
    else
      redirect_to admin_orders_path, alert: "Failed to update order."
    end
  end
  private

  def set_order
    @order = Order.find(params[:id])
  end

  
end