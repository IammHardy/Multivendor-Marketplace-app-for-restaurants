# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  include ERB::Util
  before_action :authenticate_user!, only: [ :new, :create, :payment, :mark_as_paid ]

  require "prawn"
  require "prawn/table"

  def index
    @orders = current_user.orders.order(created_at: :desc)
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
    @order = Order.includes(order_items: :food).find(params[:id])
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
end
