class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :food

  before_validation :set_unit_price

  validates :quantity, numericality: { greater_than: 0 }

  # Total price for this cart item
  def total_price
    food.price * quantity
  end

  
  def subtotal
    quantity * food.price
  end

  private

  def set_unit_price
    self.unit_price ||= food.price if food.present?
  end
end
