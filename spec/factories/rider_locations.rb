FactoryBot.define do
  factory :rider_location do
    rider { nil }
    order { nil }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end
