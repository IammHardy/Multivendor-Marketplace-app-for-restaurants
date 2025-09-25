# spec/factories/vendor_earnings.rb
FactoryBot.define do
  factory :vendor_earning do
    association :vendor
    association :order
    association :order_item
    amount { order_item.vendor_earnings }
    status { "pending" }
  end
end
