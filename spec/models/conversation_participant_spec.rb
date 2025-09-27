require 'rails_helper'

RSpec.describe ConversationParticipant, type: :model do
  describe 'database columns' do
    it { should have_db_column(:conversation_id) }
    it { should have_db_column(:participant_id) }
    it { should have_db_column(:participant_type) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:participant) } # polymorphic
  end
end
