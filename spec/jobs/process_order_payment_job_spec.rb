# app/jobs/process_order_payment_job.rb
# spec/jobs/process_order_payment_job_spec.rb
require 'rails_helper'  # <--- this must be at the very top

class ProcessOrderPaymentJob < ApplicationJob
  queue_as :default

  def perform(order_id:, auto_payout: false, payout_mode: nil)
    order = Order.find(order_id)
    return unless order.status_pending? || order.status_processing?

    # Mark order as paid
    order.update!(status: :paid)

    # Ensure each order_item has proper commissions & vendor earnings calculated
    order.order_items.each(&:set_price_and_commissions)

    # Create or update vendor earnings for each order_item
    order.order_items.includes(:vendor).each do |item|
      next unless item.vendor

      earning = VendorEarning.find_or_initialize_by(
        vendor: item.vendor,
        order: order,
        order_item: item
      )

      # Set amount from order_item
      earning.amount = item.vendor_earnings

      # Always set status if blank
      earning.status ||= 'pending'

      # Auto payout or simulate mode
      if auto_payout && payout_mode == :simulate
        earning.status = 'paid'
        earning.paid_at ||= Time.current
      end

      earning.save!
    end
  end
end
