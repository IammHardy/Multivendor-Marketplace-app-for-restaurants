class MakeVendorIdNotNullOnOrderItems < ActiveRecord::Migration[8.0]
  def change
    change_column_null :order_items, :vendor_id, false
  end
end
