class AddStatusAndOrderItemToVendorEarnings < ActiveRecord::Migration[8.0]
  def change
    # Only add if it doesn’t already exist
    unless column_exists?(:vendor_earnings, :order_item_id)
      add_reference :vendor_earnings, :order_item, foreign_key: true
    end
  end
end
