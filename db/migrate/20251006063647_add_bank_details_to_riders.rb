class AddBankDetailsToRiders < ActiveRecord::Migration[8.0]
  def change
    add_column :riders, :bank_name, :string
    add_column :riders, :account_name, :string
    add_column :riders, :account_number, :string
  end
end
