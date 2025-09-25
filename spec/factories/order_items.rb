# spec/factories/order_items.rb
FactoryBot.define do
  factory :order_item do
    association :order
    association :food
    association :vendor, factory: :vendor
    quantity { 1 }

    # Automatically calculate price, commission, and vendor earnings
    after(:build) do |item|
      item.price = item.food.price * item.quantity
      item.platform_commission = (item.price * 0.10).round(2)
      item.vendor_earnings = (item.price - item.platform_commission).round(2)
    end
  end
end
