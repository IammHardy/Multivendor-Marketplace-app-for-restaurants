class Vendor < ApplicationRecord
  # === Devise Authentication ===
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable

  # === Associations ===
  has_many :foods, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :vendor_earnings, dependent: :destroy
   has_many :order_items
  has_many :orders, through: :order_items
  has_many :vendor_reviews, dependent: :destroy

  has_many :conversation_participants, as: :participant
  has_many :conversations, through: :conversation_participants
  has_many :messages, as: :sender

  # === Active Storage Attachments ===
  has_one_attached :profile_image
  has_one_attached :banner_image
  has_one_attached :id_card

  # === Enum for vendor status ===
  enum(:status, { pending_approval: 0, active: 1, suspended: 2 })

  # Virtual attribute to track current validation step
  attr_accessor :validation_step

  # === Step 1 Validations ===
  validates :name, presence: true, length: { maximum: 255 }, if: -> { validation_step == 1 }
  validates :phone, presence: true,
                    format: { with: /\A[0-9+\-\s]+\z/, message: "only allows numbers and +, -" },
                    if: -> { validation_step == 1 }

  # === Step 2 Validations ===
  validates :contact_person, :address, :city, :business_type, presence: true, if: -> { validation_step == 2 }

  # === Step 3 Validations ===
  validates :cac_number, presence: true, if: -> { validation_step == 3 }
  validates :bio, length: { maximum: 500 }, if: -> { validation_step == 3 }
  validates :whatsapp,
            format: { with: /\A[0-9+\-\s]+\z/, message: "only allows numbers and +, -" },
            allow_blank: true,
            if: -> { validation_step == 3 }
  validate :id_card_presence_and_type, if: -> { validation_step == 3 }

  # === Step 4 Validations ===
  validates :payout_method, inclusion: { in: %w[bank transfer paypal] }, allow_blank: true, if: -> { validation_step == 4 }
  validate :profile_and_banner_presence_and_type, if: -> { validation_step == 4 }

  # === Optional Bank Account Validations ===
  validates :account_number,
            length: { is: 10 },
            numericality: { only_integer: true },
            allow_blank: true,
            if: -> { validation_step == 4 }

  validates :account_name, presence: true, if: -> { validation_step == 4 && account_number.present? }
  validates :bank_name, presence: true, if: -> { validation_step == 4 && account_number.present? }

  # === Custom validation methods ===
  def id_card_presence_and_type
    if !id_card.attached?
      errors.add(:id_card, "must be attached")
    elsif !id_card.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:id_card, "must be PNG, JPG, or JPEG")
    elsif id_card.byte_size > 5.megabytes
      errors.add(:id_card, "size must be less than 5MB")
    end
  end

  def profile_and_banner_presence_and_type
    if !profile_image.attached?
      errors.add(:profile_image, "must be attached")
    elsif !profile_image.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:profile_image, "must be PNG, JPG, or JPEG")
    elsif profile_image.byte_size > 5.megabytes
      errors.add(:profile_image, "size must be less than 5MB")
    end

    if !banner_image.attached?
      errors.add(:banner_image, "must be attached")
    elsif !banner_image.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:banner_image, "must be PNG, JPG, or JPEG")
    elsif banner_image.byte_size > 5.megabytes
      errors.add(:banner_image, "size must be less than 5MB")
    end
  end

  # === Earnings methods ===
  def total_balance
    vendor_earnings.sum(:amount)
  end

  def pending_balance
    vendor_earnings.where(status: "pending").sum(:amount)
  end

  def paid_out_balance
    vendor_earnings.where(status: "paid").sum(:amount)
  end

  # === Orders ===
  def total_orders
    order_items.select(:order_id).distinct.count
  end

  # Only allow login if vendor is active
  def active_for_authentication?
    super && active?
  end

  # Custom message for rejected or pending vendors
  def inactive_message
    if rejected?
      :rejected_account
    elsif pending_approval?
      :not_approved
    else
      super
    end
  end

  # Only show active vendors
  scope :approved, -> { where(status: :active) }

  # Only show foods that are active/available
  has_many :active_foods, -> { where(active: true) }, class_name: "Food"

  # Reviews through foods (optional)
  has_many :reviews, through: :foods

  # Average rating helper
  def average_rating
    reviews.average(:rating)&.round(1)
  end

  # Total number of reviews
  def reviews_count
    reviews.count
  end
end
