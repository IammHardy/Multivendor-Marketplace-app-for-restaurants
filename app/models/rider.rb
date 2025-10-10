class Rider < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_one_attached :photo
  has_one_attached :id_card
  has_one_attached :license_plate_image
  has_many :orders
  has_many :rider_locations, dependent: :destroy

  # Rider account status on the platform
  enum :status, { pending: 0, active: 1, suspended: 2, rejected: 3 }

  # Scope for available riders (for orders)
  scope :available, -> { where(status: :active) }

  # Validations
  with_options if: -> { validation_step.to_i >= 3 } do |rider|
    rider.validates :address, :state, :city, :bank_name, :account_name, :account_number, presence: true
  end

  attr_accessor :validation_step

  # Authentication restriction
  def active_for_authentication?
    super && active?
  end

  def inactive_message
    if rejected?
      :rejected_account
    elsif pending?
      :not_approved
    elsif suspended?
      :suspended_account
    else
      super
    end
  end
end
