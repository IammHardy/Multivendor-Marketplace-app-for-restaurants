class Conversation < ApplicationRecord
  belongs_to :user       # maps automatically to user_id
  belongs_to :vendor
  has_many :conversation_participants, dependent: :destroy
  has_many :participants, through: :conversation_participants, source: :participant
  has_many :messages, dependent: :destroy

  # Find or create a conversation for a user & vendor pair
  def self.find_or_create_for(user:, vendor:)
    find_by(user_id: user.id, vendor_id: vendor.id) ||
      create!(user_id: user.id, vendor_id: vendor.id)
  end
end
