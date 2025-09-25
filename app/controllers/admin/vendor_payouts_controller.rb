module Admin
  class VendorPayoutsController < Admin::BaseController
    before_action :authenticate_admin!

    def index
      @vendors_with_pending = Vendor.joins(:vendor_earnings)
                                   .merge(VendorEarning.pending)
                                   .distinct
                                   .select("vendors.*, SUM(vendor_earnings.amount) as pending_amount")
                                   .group("vendors.id")
    end

    def pay
      vendor = Vendor.find(params[:vendor_id])
      mode   = params[:mode]&.to_sym || :simulate

      # Always enqueue — don’t block the request thread
      VendorPayoutJob.perform_later(vendor.id, mode, current_admin.id)

      redirect_to admin_vendor_payouts_path, notice: "Payout queued for #{vendor.name}"
    end
  end
end
