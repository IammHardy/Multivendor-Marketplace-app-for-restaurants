class AddStateToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :state, :string
  end
end
