class AddSenderToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :sender_id, :integer
    add_column :messages, :sender_type, :string
  end
end
