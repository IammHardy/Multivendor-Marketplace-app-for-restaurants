FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    after(:build) do |u|
      u.skip_confirmation! if u.respond_to?(:skip_confirmation!)
    end
  end
end
