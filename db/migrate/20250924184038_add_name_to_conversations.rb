class AddNameToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :name, :string
  end
end
