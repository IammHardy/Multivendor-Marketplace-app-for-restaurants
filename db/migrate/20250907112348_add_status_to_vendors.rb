class AddStatusToVendors < ActiveRecord::Migration[8.0]
  def change
     add_column :vendors, :status, :integer
  end
end
