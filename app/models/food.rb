class Food < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_one_attached :image
  has_many :food_categories, dependent: :destroy
  has_many :categories, through: :food_categories
  has_many :promotions, dependent: :destroy
  
   belongs_to :vendor, required: true  # ensures presence validation automatically
  validates :name, presence: true 
  extend FriendlyId
  friendly_id :name, use: :slugged

  before_save :round_price

  def active_promotions
  promotions.where(active: true).where("starts_at <= ? AND ends_at >= ?", Time.current, Time.current)
end

def out_of_stock?
    !in_stock
  end

    scope :on_promotion, -> { joins(:promotion).merge(Promotion.active) }
  
private

def round_price
  self.price = price.to_d.round(2) if price.present?
end
 


  # Scope to include associations for efficient queries
  scope :with_associations, -> { includes(:category, :reviews) }
end
