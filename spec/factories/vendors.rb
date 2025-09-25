FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    active { true }
  end
end
