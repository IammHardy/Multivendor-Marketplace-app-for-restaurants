class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :food
  belongs_to :vendor

  before_validation :set_price_and_commissions

  has_one :vendor_earning, dependent: :destroy

  private

  def set_price_and_commissions
    unit_price = food.price # already decimal(10,2), safer than float
    self.subtotal = (unit_price * quantity).round(2)

    self.price = subtotal # keep consistency
    self.platform_commission = (subtotal * 0.10).round(2)
    self.vendor_earnings = (subtotal - platform_commission).round(2)
  end
end
