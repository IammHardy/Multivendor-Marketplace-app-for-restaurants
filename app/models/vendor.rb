class Vendor < ApplicationRecord
  # === Devise Authentication ===
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  # === Associations ===
  has_many :foods, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items, dependent: :destroy
  has_many :vendor_earnings, dependent: :destroy
  has_many :vendor_reviews, dependent: :destroy
  has_many :conversation_participants, as: :participant
  has_many :conversations, through: :conversation_participants
  has_many :messages, as: :sender
  has_many :reviews, through: :foods
  has_many :promotions, dependent: :destroy
  has_many :carts


  # === Active Storage Attachments ===
  has_one_attached :profile_image
  has_one_attached :banner_image
  has_one_attached :id_card

  # === Enums ===
  enum :status, { pending_approval: 0, active: 1, suspended: 2, rejected: 3 }

  # === Slugging ===
  extend FriendlyId
  friendly_id :name, use: :slugged

  # === Virtual attribute for multi-step validation ===
  attr_accessor :validation_step


  # === Terms and Conditions ===
validates :terms_accepted, acceptance: { message: "must be accepted before continuing" }, if: -> { validation_step == 1 }

  # === Step 1: Basic Info ===
  validates :name, presence: true, length: { maximum: 255 }, if: -> { validation_step == 1 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { validation_step == 1 }
  validates :phone, presence: true, uniqueness: true,
                    format: { with: /\A[0-9+\-\s]+\z/, message: "only allows numbers and +, -" },
                    if: -> { validation_step == 1 }
  validates :password, presence: true,
                     length: { minimum: 6 },
                     confirmation: true,
                     if: -> { validation_step == 1 }


  # === Step 2: Business Info ===
  validates :contact_person, :address, :city, presence: true, if: -> { validation_step == 2 }
  validates :business_type,
            presence: true,
            inclusion: { in: ["Restaurant", "Bakery", "Drinks", "Catering", "Others"] },
            if: -> { validation_step == 2 }

  # === Step 3: Legal & Profile Info ===
  validates :cac_number, presence: true,
                         uniqueness: true,
                         format: { with: /\A[A-Z0-9]+\z/, message: "must contain only letters and numbers" },
                         if: -> { validation_step == 3 }
  validates :bio, length: { maximum: 500 }, allow_blank: true, if: -> { validation_step == 3 }
  validates :whatsapp,
            format: { with: /\A[0-9+\-\s]+\z/, message: "only allows numbers and +, -" },
            allow_blank: true,
            if: -> { validation_step == 3 }
  validate :id_card_presence_and_type, if: -> { validation_step == 3 }

  # === Step 4: Payment / Payout Info ===
  validates :payout_method,
            inclusion: { in: %w[bank_transfer paypal paystack flutterwave] },
            allow_blank: true,
            if: -> { validation_step == 4 }

  validates :account_number,
            length: { is: 10 },
            numericality: { only_integer: true },
            allow_blank: true,
            if: -> { validation_step == 4 }

  validates :account_name, presence: true, if: -> { validation_step == 4 && account_number.present? }
  validates :bank_name, presence: true, if: -> { validation_step == 4 && account_number.present? }
  validate :profile_and_banner_presence_and_type, if: -> { validation_step == 4 }

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

  def valid_profile_image?
  profile_image.attached? && profile_image.blob&.service.exist?(profile_image.key)
rescue ActiveStorage::FileNotFoundError, Errno::ENOENT
  false
end

def valid_banner_image?
  banner_image.attached? && banner_image.blob&.service.exist?(banner_image.key)
rescue ActiveStorage::FileNotFoundError, Errno::ENOENT
  false
end

  # === Earnings ===
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

  # === Reviews ===
  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def reviews_count
    reviews.count
  end

  def starting_price
    foods.minimum(:price) || 0
  end

  # === Authentication restrictions ===
  def active_for_authentication?
    super && active?
  end

  def inactive_message
    if rejected?
      :rejected_account
    elsif pending_approval?
      :not_approved
    else
      super
    end
  end

 

  # === Scopes ===
  scope :approved, -> { where(status: :active) }
  has_many :active_foods, -> { where(active: true) }, class_name: "Food"
end
