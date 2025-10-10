class AddRiderToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :rider, null: true, foreign_key: true
    add_column :orders, :delivery_fee, :decimal
    add_column :orders, :delivery_address, :string
  end
end
