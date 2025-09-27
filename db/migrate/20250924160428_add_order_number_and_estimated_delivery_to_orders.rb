class AddOrderNumberAndEstimatedDeliveryToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :order_number, :string
    add_column :orders, :estimated_delivery_time, :datetime
    add_index  :orders, :order_number, unique: true
  end
end
