FactoryBot.define do
  factory :food do
    sequence(:name) { |n| "Food #{n}" }
    price { 100.0 }
    association :vendor
  end
end
