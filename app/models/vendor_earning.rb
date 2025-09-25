class VendorEarning < ApplicationRecord
  belongs_to :vendor
  belongs_to :order
  belongs_to :order_item, optional: true

  enum(:status, { pending: 0, paid: 1, failed: 2 }, prefix: true)

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # no need for after_initialize now, enum default handles it
end
