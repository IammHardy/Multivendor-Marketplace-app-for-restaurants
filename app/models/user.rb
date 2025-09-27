class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [ :google_oauth2, :tiktok, :facebook ]

  # Associations
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items
  has_many :vendor_reviews, dependent: :destroy
   has_many :support_tickets
  after_create :create_cart

  has_many :conversation_participants, as: :participant
  has_many :conversations, through: :conversation_participants
  
  has_many :messages, as: :sender

  # Roles: customer (default), vendor, admin
  enum(:role, { customer: 0, vendor: 1, admin: 2 })

  # Validations
  validates :role, presence: true

  # Ransack (safe search)
  def self.ransackable_attributes(_auth_object = nil)
    %w[id email role created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  # OmniAuth login handler
  def self.from_omniauth(auth)
    return nil unless auth

    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
    user.password ||= Devise.friendly_token[0, 20]
    user.name = auth.info.name if user.respond_to?(:name)
    user.confirmed_at ||= Time.current
    user.role ||= :customer
    user.save!
    user
  end

  private

  def create_cart
    create_cart! if customer? # only create carts for customers
  end
end
