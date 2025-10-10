FactoryBot.define do
  factory :rider do
    name { "MyString" }
    phone { "MyString" }
    vehicle_type { "MyString" }
    verified { false }
    status { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end
