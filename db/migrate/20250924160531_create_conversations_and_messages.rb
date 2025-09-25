class CreateConversationsAndMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.timestamps
    end

    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :sender_user, foreign_key: { to_table: :users }   # user may send
      t.references :sender_vendor, foreign_key: { to_table: :vendors } # vendor may send
      t.text :body, null: false
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
