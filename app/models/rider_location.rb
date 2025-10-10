class RiderLocation < ApplicationRecord
  belongs_to :rider
  belongs_to :order

  validates :latitude, :longitude, presence: true
end