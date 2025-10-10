class AddLockableToRiders < ActiveRecord::Migration[8.0]
  def change
    add_column :riders, :failed_attempts, :integer
    add_column :riders, :unlock_token, :string
    add_column :riders, :locked_at, :datetime
  end
end
