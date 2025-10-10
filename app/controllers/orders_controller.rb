# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  include ERB::Util
  before_action :authenticate_user!, only: [ :new, :show, :create, :payment, :mark_as_paid, :message_admin, :download_summary, :track ]
    before_action :set_order, only: [:show, :download_summary, :message_admin, :track]

  require "prawn"
  require "prawn/table"

  def index
  @orders = current_user.orders.order(created_at: :desc)

  respond_to do |format|
    format.html # renders index.html.erb
    format.json do
      render json: @orders.map { |order|
        rider = order.rider
        latest_location = rider&.rider_locations&.order(created_at: :desc)&.first

        {
          id: order.id,
          status: order.status,
          delivery_status: order.delivery_status,
          total_price: order.total_price,
          name: order.name,
          created_at: order.created_at,
          rider: rider ? {
            name: rider.name,
            phone: rider.phone,
            lat: latest_location&.latitude,
            lng: latest_location&.longitude
          } : nil
        }
      }
    end
  end
end


  def new
    @order = Order.new
  end

  def create
  @order = current_user.orders.new(order_params)
  @order.status = :pending

  if @order.save
    current_cart.cart_items.each do |cart_item|
      @order.order_items.create(
        food: cart_item.food,
        vendor: cart_item.food.vendor,
        quantity: cart_item.quantity,
        price: cart_item.food.price || 0
      )
    end

    @order.calculate_total_price
    @order.save!

    current_cart.cart_items.destroy_all
    flash[:notice] = "Order placed successfully."
    redirect_to order_path(@order)
  else
    render :new
  end
end


  def show
  @order = Order.find(params[:id])

  respond_to do |format|
    format.html # renders show.html.erb
    format.json { render json: { lat: @order.latitude, lng: @order.longitude, status: @order.status } }
  end
end


def track
  return render json: { error: "Order not found" }, status: :not_found unless @order

  vendor = @order.foods.first&.vendor
  rider_location = @order.rider&.rider_locations&.order(created_at: :desc)&.first

  response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"

  respond_to do |format|
    format.html # 👈 this will render app/views/orders/track.html.erb
    format.json do # 👈 only return JSON when explicitly requested
      render json: {
        lat: rider_location&.latitude,
        lng: rider_location&.longitude,
        pickup_lat: vendor&.latitude || 9.0765,
        pickup_lng: vendor&.longitude || 7.3986,
        destination_lat: @order.latitude,
        destination_lng: @order.longitude,
        status: @order.status
      }
    end
  end
end

def accept_order
  order = Order.find(params[:order_id])

  if order.delivery_status_pending?
    order.update(rider: current_rider, delivery_status: :assigned)
    render json: { success: true, message: "Order accepted!" }
  else
    render json: { error: "Order already taken" }, status: :unprocessable_entity
  end
end



  def payment
    @order = current_user.orders.find(params[:id])
  end

  def mark_as_paid
    order = Order.find(params[:id])
    # Trigger job to calculate vendor earnings
    ProcessOrderPaymentJob.perform_later(
      order_id: order.id,
      auto_payout: true,
      payout_mode: :simulate
    )

    redirect_to order_path(order), notice: "Order payment is being processed."
  end

  def message_admin
    @order = Order.find(params[:id])
    total_price = @order.total_price || @order.order_items.sum { |item| item.food.price * item.quantity }
    user_name = @order.user&.email || "Customer"

    message = url_encode(
      "Hello Admin, I just paid for Order ##{@order.id}.\n"\
      "Name: #{user_name}\nTotal: ₦#{total_price}\nPlease confirm."
    )

    redirect_to "https://wa.me/2349038311561?text=#{message}", allow_other_host: true
  end

  def download_summary
    @order = Order.find(params[:id])

    pdf = Prawn::Document.new
    font_path = Rails.root.join("app/assets/fonts/DejaVuSans.ttf")
    pdf.font_families.update("DejaVuSans" => { normal: font_path, bold: font_path })
    pdf.font "DejaVuSans"

    pdf.text "Order Summary", size: 20, style: :bold
    pdf.move_down 10

    pdf.text "Order ID: ##{@order.id}"
    pdf.text "Reference: #{@order.payment_reference || 'N/A'}"
    pdf.text "Customer: #{@order.name || 'N/A'}"
    pdf.text "Address: #{@order.address}"
    pdf.text "Status: #{@order.status.capitalize}"
    pdf.text "Total: ₦#{@order.total_price}"
    pdf.text "Date: #{@order.updated_at.strftime('%d %B %Y, %I:%M %p')}"
    pdf.move_down 20

    pdf.text "Items", style: :bold
    pdf.move_down 10

    table_data = [ [ "Item", "Qty", "Unit Price", "Total" ] ]
    @order.order_items.each do |item|
      table_data << [
        item.food.name,
        item.quantity,
        "₦#{'%.2f' % item.food.price}",
        "₦#{'%.2f' % (item.food.price * item.quantity)}"
      ]
    end

    pdf.table(table_data, header: true, row_colors: [ "F0F0F0", "FFFFFF" ], width: pdf.bounds.width)
    pdf.move_down 20
    pdf.text "Thank you for your order!", size: 14, style: :bold, align: :center

    send_data pdf.render, filename: "order_summary_#{@order.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :phone)
  end


   # ✅ Only fetch orders for the current user
  def set_order
    @order = current_user.orders.find_by(id: params[:id])
    redirect_to orders_path, alert: "Order not found." unless @order
  end
end


