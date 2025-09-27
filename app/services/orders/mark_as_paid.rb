# app/services/orders/mark_as_paid.rb
module Orders
  class MarkAsPaid
    Result = Struct.new(:success?, :errors, :vendors_paid)

    def initialize(order:, auto_payout: false, payout_mode: :simulate, initiated_by: nil)
      @order = order
      @auto_payout = auto_payout
      @payout_mode = payout_mode
      @initiated_by = initiated_by
      @errors = []
      @vendors_paid = []
    end

    def call
      ActiveRecord::Base.transaction do
        begin
          mark_order_paid!
          process_vendor_payouts if @auto_payout
          Result.new(true, [], @vendors_paid)
        rescue => e
          @errors << e.message
          raise ActiveRecord::Rollback
        end
      end
    rescue
      Result.new(false, @errors, [])
    end

    private

    def mark_order_paid!
      return if @order.paid? # ✅ skip if already paid
      @order.update!(status: :paid)
    end

    def process_vendor_payouts
  @order.order_items.includes(:vendor).each do |item|
    next if item.vendor_earning.present?

    earning = item.create_vendor_earning!(amount: item.vendor_earnings)

    if @payout_mode == :simulate
      earning.mark_paid!(Time.current)
    elsif @payout_mode == :paystack
      VendorPayoutService.new(vendor: item.vendor, initiated_by: @initiated_by).pay_all_pending!(mode: :paystack)
    end

    @vendors_paid << { vendor: item.vendor, amount: earning.amount }
  end
end
  end
end
