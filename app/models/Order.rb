class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart, optional: true
  belongs_to :food   # make sure this exists

  has_many :order_items, dependent: :destroy
  has_many :vendor_earnings, dependent: :destroy
   has_many :foods, through: :order_items  # ✅ Add this line

  # Enum for status with prefix methods like status_pending?
  enum(:status, { pending: 0, processing: 1, paid: 2, completed: 3, cancelled: 4 }, prefix: true)

  
  # Returns the first vendor associated with this order's foods
  def vendor
    foods.first&.vendor
  end
   # Optional: create a conversation for this order if it doesn't exist
  def vendor_conversation
  Conversation.find_or_create_by(
    user_id: user_id,          # ✅ use foreign key column
    vendor_id: vendor&.id,     # ✅ use foreign key column
    name: "Order ##{id}"
  ) if vendor
end

  # Callbacks
  before_save :calculate_total_price
  after_update :create_vendor_earnings, if: :just_paid?

  # Check if order just changed to paid
  def just_paid?
    saved_change_to_status? && status_paid?
  end

  # Public method to calculate total price (used in specs)
  def calculate_total!
    total = order_items.includes(:food).sum do |item|
      item.price || item.food.price * item.quantity
    end
    update!(total_price: total)
  end
  def vendors
    order_items.includes(:vendor).map(&:vendor).uniq.compact
  end

  private

  # Callback: calculate total price before saving
  def calculate_total_price
    self.total_price = order_items.includes(:food).sum do |item|
      item.price || item.food.price * item.quantity
    end
  end

  # Callback: create vendor earnings after payment
  def create_vendor_earnings
    order_items.includes(:vendor).each do |item|
      next unless item.vendor

      # Ensure vendor earnings are calculated
      item.set_price_and_commissions if item.vendor_earnings.nil?

      earning = VendorEarning.find_or_initialize_by(
        vendor: item.vendor,
        order: self,
        order_item: item
      )

      earning.amount ||= item.vendor_earnings
      earning.status ||= "pending"  # always set status
      earning.save!
    end
  end

  def generate_order_number
    loop do
      token = "ORD-#{SecureRandom.hex(4).upcase}"
      unless self.class.exists?(order_number: token)
        self.order_number = token
        break
      end
    end
  end

  def set_default_estimated_time
    # default 45 minutes from creation; adjust as necessary
    update_column(:estimated_delivery_time, created_at + 45.minutes)
  end

  

   
end
