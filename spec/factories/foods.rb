# spec/factories/foods.rb
FactoryBot.define do
  factory :food do
    name { "Test Food" }
    price { 100.0 }   # <- important for calculations
    description { "Delicious food" }
    vendor
  end
end
