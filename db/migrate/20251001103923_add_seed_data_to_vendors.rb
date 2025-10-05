class AddSeedDataToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :seed_data, :boolean, default: false, null: false
  end
end
