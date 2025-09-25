class AddLockableToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :failed_attempts, :integer, default: 0, null: false
    add_column :vendors, :unlock_token, :string
    add_column :vendors, :locked_at, :datetime

    add_index :vendors, :unlock_token, unique: true
  end
end
