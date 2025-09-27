# spec/factories/vendors.rb
FactoryBot.define do
  factory :vendor do
    sequence(:email) { |n| "vendor#{n}@example.com" } # ensures unique email
    name { "Vendor Name" }
    password { "password123" }
    # add other required fields
  end
end
