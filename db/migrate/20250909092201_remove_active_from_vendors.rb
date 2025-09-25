class RemoveActiveFromVendors < ActiveRecord::Migration[8.0]
  def change
    remove_column :vendors, :active, :boolean, if_exists: true
    remove_column :vendors, :vendor_status, :integer, if_exists: true
  end
end
