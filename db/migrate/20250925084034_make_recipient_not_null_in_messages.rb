class MakeRecipientNotNullInMessages < ActiveRecord::Migration[8.0]
  def change
    change_column_null :messages, :recipient_id, false
    change_column_null :messages, :recipient_type, false
  end
end
