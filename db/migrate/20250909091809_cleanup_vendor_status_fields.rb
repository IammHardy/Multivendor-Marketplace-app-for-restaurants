class CleanupVendorStatusFields < ActiveRecord::Migration[8.0]
  def change
    # Remove the old active boolean column
    if column_exists?(:vendors, :active)
      remove_column :vendors, :active, :boolean
    end

    # Remove vendor_status if it was ever added
    if column_exists?(:vendors, :vendor_status)
      remove_column :vendors, :vendor_status, :integer
    end
  end
end
