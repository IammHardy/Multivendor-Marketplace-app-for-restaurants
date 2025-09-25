class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true

  validates :body, presence: true

  scope :unread, -> { where(read: false) }
end
