class AddVendorIdToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_column :cart_items, :vendor_id, :integer
  end
end
