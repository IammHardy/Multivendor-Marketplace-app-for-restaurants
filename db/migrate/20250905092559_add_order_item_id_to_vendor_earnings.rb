class AddOrderItemIdToVendorEarnings < ActiveRecord::Migration[8.0]
  def change
    add_reference :vendor_earnings, :order_item, null: false, foreign_key: true
  end
end
