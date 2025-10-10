class RemoveStatusFromRiders < ActiveRecord::Migration[8.0]
  def change
    remove_column :riders, :status, :string
  end
end
