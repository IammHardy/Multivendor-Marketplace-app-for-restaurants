class AddSlugToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :slug, :string
    add_index :vendors, :slug, unique: true
  end
end
