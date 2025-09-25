class SupportTicket < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :user, optional: true

  validates :body, presence: true
  validates :status, inclusion: { in: %w[open pending resolved closed] }
end
