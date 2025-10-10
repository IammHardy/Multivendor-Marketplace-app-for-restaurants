class AddDeliveryStatusToRiders < ActiveRecord::Migration[8.0]
  def change
    add_column :riders, :delivery_status, :string
  end
end
