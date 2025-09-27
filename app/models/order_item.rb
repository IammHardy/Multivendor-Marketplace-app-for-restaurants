class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :food
  belongs_to :vendor

 before_validation :set_price_and_commissions
 has_one :vendor_earning, dependent: :destroy  # ✅ add this

  def set_price_and_commissions
    self.price = food.price * quantity
    self.platform_commission = (price * 0.10).round(2)
    self.vendor_earnings = price - platform_commission
    # No save! here — Rails will save automatically after this callback
  end
end
