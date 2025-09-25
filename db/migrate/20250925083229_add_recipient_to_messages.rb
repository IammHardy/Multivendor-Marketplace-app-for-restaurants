class AddRecipientToMessages < ActiveRecord::Migration[8.0]
  def change
   add_reference :messages, :recipient, polymorphic: true, null: true
  end
end
