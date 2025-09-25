class VendorReview < ApplicationRecord
  belongs_to :vendor
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { maximum: 500 }
end
