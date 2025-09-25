class ConversationParticipant < ApplicationRecord
  belongs_to :conversation
  belongs_to :participant, polymorphic: true
end
