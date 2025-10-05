
class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :foods, through: :cart_items

def total_price
    cart_items.sum(&:total_price)
  end
  
  def items
    cart_items
  end
end
