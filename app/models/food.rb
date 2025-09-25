class Food < ApplicationRecord
  
  belongs_to :vendor, optional: true
  has_many :reviews, dependent: :destroy
  has_many :order_items
  has_one_attached :image
  has_many :food_categories, dependent: :destroy
  has_many :categories, through: :food_categories

  extend FriendlyId
  friendly_id :name, use: :slugged

  # Scope to include associations for efficient queries
  scope :with_associations, -> { includes(:category, :reviews) }
end
