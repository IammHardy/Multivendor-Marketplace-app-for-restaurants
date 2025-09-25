class UpgradeVendorEarningsSchema < ActiveRecord::Migration[8.0]
  def change
    # Add new fields
    add_column :vendor_earnings, :status, :string, default: "pending", null: false
    add_column :vendor_earnings, :paid_at, :datetime

    # Drop old field if you don’t need it anymore
    remove_column :vendor_earnings, :paid_out, :boolean
  end
end
