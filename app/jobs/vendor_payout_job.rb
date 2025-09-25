class VendorPayoutJob < ApplicationJob
  queue_as :default

  def perform(vendor_id, mode, admin_id)
    vendor = Vendor.find_by(id: vendor_id)
    return unless vendor

    admin = Admin.find_by(id: admin_id)

    service = VendorPayoutService.new(vendor: vendor, initiated_by: admin)
    result  = service.pay_all_pending!(mode: mode)

    if result.success?
      Rails.logger.info "✅ Paid #{result.amount} to #{vendor.name} via #{mode}"
    else
      Rails.logger.error "❌ Payout failed for #{vendor.name}: #{result.error_message || result.details}"
    end
  end
end
