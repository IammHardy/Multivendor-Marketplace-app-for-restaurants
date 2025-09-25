class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :food
  belongs_to :vendor, optional: true

  before_create :set_price_and_commissions

  private

  def set_price_and_commissions
    self.price = food.price * quantity
    self.platform_commission = (price * 0.10).round(2)
    self.vendor_earnings = price - platform_commission
    # No save! here — Rails will save automatically after this callback
  end
end
