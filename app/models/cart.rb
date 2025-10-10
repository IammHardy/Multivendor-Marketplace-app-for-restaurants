class Cart < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :vendor, optional: true

  has_many :cart_items, dependent: :destroy
  has_many :foods, through: :cart_items

  # ✅ Calculate total cart price
  def total_price
    cart_items.includes(:food).sum { |item| item.food.price * item.quantity }
  end

  def items
    cart_items
  end

  # ✅ Add food to cart safely (only one vendor at a time)
  def add_food(food)
    if vendor.present? && vendor != food.vendor
      errors.add(:base, "You can only order from one restaurant at a time.")
      return false
    end

    self.vendor ||= food.vendor

    existing_item = cart_items.find_by(food_id: food.id)
    if existing_item
      existing_item.increment!(:quantity)
    else
      cart_items.create(food: food, quantity: 1)
    end
  end

  # ✅ Clear cart when user switches vendor
  def clear_cart
    cart_items.destroy_all
    update(vendor: nil)
  end
end
