class AddLockableToRiders < ActiveRecord::Migration[8.0]
  def change
    add_column :riders, :failed_attempts, :integer, default: 0, null: false
    add_column :riders, :unlock_token, :string
    add_column :riders, :locked_at, :datetime
    add_index :riders, :unlock_token, unique: true
  end
end
