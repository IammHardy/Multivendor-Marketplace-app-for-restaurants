class AddVendorAndCommissionToOrderItems < ActiveRecord::Migration[8.0]
  def change
    # Add vendor reference nullable
    add_reference :order_items, :vendor, foreign_key: true, null: true

    # Add commission fields
    add_column :order_items, :platform_commission, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :order_items, :vendor_earnings, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
