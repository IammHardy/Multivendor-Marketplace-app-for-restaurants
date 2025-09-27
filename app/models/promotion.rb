class Promotion < ApplicationRecord
  has_one_attached :image
  belongs_to :vendor, optional: true
  belongs_to :food, optional: true

  

  # Only show currently active promotions
  scope :active, -> {
    where(active: true)
      .where('starts_at IS NULL OR starts_at <= ?', Time.current)
      .where('ends_at IS NULL OR ends_at >= ?', Time.current)
  }

  validates :title, presence: true
   validates :cta_text, presence: true, if: -> { cta_url.present? }
end
