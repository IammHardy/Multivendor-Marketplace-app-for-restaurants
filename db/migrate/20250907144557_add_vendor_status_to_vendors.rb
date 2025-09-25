class AddVendorStatusToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :vendor_status, :integer
  end
end
