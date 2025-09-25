FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    
    # Skip Devise confirmation if Devise is installed
    after(:build) do |u|
      u.skip_confirmation! if u.respond_to?(:skip_confirmation!)
    end

    # Skip any Devise modules that may require mapping
    to_create(&:save)
  end
end
