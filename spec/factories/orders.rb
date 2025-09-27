FactoryBot.define do
  factory :order do
    association :user
    status { :pending }
    total_price { 0.0 }
  end
end
