# app/jobs/process_order_payment_job.rb
class ProcessOrderPaymentJob < ApplicationJob
  queue_as :default

  def perform(order_id:, auto_payout: false, payout_mode: nil)
    order = Order.find(order_id)
    return unless order.status_pending? || order.status_processing?

    # Mark the order as paid
    order.update!(status: :paid)

    # Loop through each order item to create or update vendor earnings
    order.order_items.includes(:vendor).each do |item|
      next unless item.vendor

      # Ensure price & commissions are calculated
      item.set_price_and_commissions if item.vendor_earnings.nil?

      # Find or initialize VendorEarning
      earning = VendorEarning.find_or_initialize_by(
        vendor: item.vendor,
        order: order,
        order_item: item
      )

      # Set the correct amount
      earning.amount ||= item.vendor_earnings

      # Default status is pending
      earning.status = "pending" if earning.status.blank?

      # If auto_payout is true and mode is simulate, mark as paid
      if auto_payout && payout_mode == :simulate
        earning.status = "paid"
        earning.paid_at ||= Time.current
      end

      earning.save!
    end
  end
end
