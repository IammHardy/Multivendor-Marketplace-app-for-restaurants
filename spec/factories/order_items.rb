FactoryBot.define do
  factory :order_item do
    association :order
    association :food
    quantity { 1 }
    vendor { food.vendor }
    price { food.price * quantity }
    platform_commission { (price * 0.10).round(2) }
    vendor_earnings { (price - platform_commission).round(2) }
  end
end
