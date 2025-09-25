require 'httparty'

class PaymentsController < ApplicationController
  before_action :authenticate_user!

  # Initialize Paystack payment
  def pay
    order = current_user.orders.find(params[:order_id])
    amount_kobo = (order.order_items.sum { |i| i.food.price * i.quantity } * 100).to_i
    reference = "ORD#{order.id}-#{Time.now.to_i}"

    response = HTTParty.post(
      "https://api.paystack.co/transaction/initialize",
      headers: {
        "Authorization" => "Bearer #{ENV['PAYSTACK_SECRET_KEY']}",
        "Content-Type" => "application/json"
      },
      body: {
        email: current_user.email,
        amount: amount_kobo,
        reference: reference,
        callback_url: verify_payment_url
      }.to_json
    )

    if response.parsed_response["status"]
      order.update!(payment_reference: reference)
      redirect_to response.parsed_response["data"]["authorization_url"], allow_other_host: true
    else
      redirect_to order_path(order), alert: "Payment failed to initialize."
    end
  end

  # Verify Paystack payment and process order
  def verify
    reference = params[:reference]
    response = HTTParty.get(
      "https://api.paystack.co/transaction/verify/#{reference}",
      headers: {
        "Authorization" => "Bearer #{ENV['PAYSTACK_SECRET_KEY']}"
      }
    )

    if response.parsed_response["status"]
      order = Order.find_by(payment_reference: reference)
      if order.present?
        # Update order status to processing
        order.update!(status: "processing")

        # Notify admin
        send_whatsapp_notification(order)
        AdminMailer.order_paid_notification(order).deliver_later

        # Automatically mark as paid and create vendor earnings
        ProcessOrderPaymentJob.perform_later(
          order_id: order.id,
          auto_payout: true,
          payout_mode: :simulate
        )

        redirect_to order_path(order), notice: "Payment verified successfully."
      else
        redirect_to root_path, alert: "Order not found."
      end
    else
      redirect_to root_path, alert: "Payment verification failed."
    end
  end

  private

  # Sends a WhatsApp notification to the admin for new paid orders
  def send_whatsapp_notification(order)
    items = order.order_items.map do |item|
      "#{item.food.name} x#{item.quantity} (₦#{item.price})"
    end.join(", ")

    message = <<~MSG
      New Paid Order!
      Name: #{order.name}
      Phone: #{order.phone}
      Address: #{order.address}
      Items: #{items}
      Total: ₦#{order.total_price}
      Status: #{order.status}
    MSG

    number = ENV['ADMIN_WHATSAPP_NUMBER']
    apikey = ENV['CALLMEBOT_API_KEY']

    HTTParty.get(
      "https://api.callmebot.com/whatsapp.php",
      query: {
        phone: number,
        text: message,
        apikey: apikey
      }
    )
  end
end
