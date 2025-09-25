class AddBankDetailsToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :bank_name, :string
    add_column :vendors, :account_name, :string
    add_column :vendors, :account_number, :string
    add_column :vendors, :payout_method, :string
  end
end
