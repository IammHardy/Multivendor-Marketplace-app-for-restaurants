class RenameConversationUsersToConversationParticipants < ActiveRecord::Migration[8.0]
  def change
    rename_table :conversation_users, :conversation_participants
    add_column :conversation_participants, :participant_type, :string
    rename_column :conversation_participants, :user_id, :participant_id
  end
end
