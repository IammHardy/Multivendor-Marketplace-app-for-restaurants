class AddDescriptionToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :description, :text
  end
end
