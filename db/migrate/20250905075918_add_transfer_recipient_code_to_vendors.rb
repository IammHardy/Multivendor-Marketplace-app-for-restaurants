class AddTransferRecipientCodeToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :transfer_recipient_code, :string
  end
end
