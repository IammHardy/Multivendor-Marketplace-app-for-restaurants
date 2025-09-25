FactoryBot.define do
  factory :vendor_review do
    vendor { nil }
    user { nil }
    rating { 1 }
    comment { "MyText" }
  end
end
