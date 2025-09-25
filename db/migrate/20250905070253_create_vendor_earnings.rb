class UpdateVendorEarningsTable < ActiveRecord::Migration[8.0]
  def change
    change_table :vendor_earnings, bulk: true do |t|
      # Add precision to amount (important for money)
      t.change :amount, :decimal, precision: 10, scale: 2, null: false, default: 0.0

      # Replace boolean with integer status (0=pending, 1=paid)
      t.remove :paid_out
      t.integer :status, default: 0, null: false
    end

    add_index :vendor_earnings, :status
  end
end
