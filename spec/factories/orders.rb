# spec/factories/orders.rb
FactoryBot.define do
  factory :order do
    association :user
    status { :pending }

    factory :order_with_items do
      transient do
        items_count { 2 }
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.items_count, order: order)
      end
    end
  end
end
