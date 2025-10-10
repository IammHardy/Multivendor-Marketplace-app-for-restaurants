class AddDeliveryStatusToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :delivery_status, :integer, default: 0
  end
end
