class AddVendorIdToCarts < ActiveRecord::Migration[8.0]
  def change
    add_column :carts, :vendor_id, :integer
  end
end
