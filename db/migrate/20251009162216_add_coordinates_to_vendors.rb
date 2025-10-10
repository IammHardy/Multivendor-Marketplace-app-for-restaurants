class AddCoordinatesToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :latitude, :float
    add_column :vendors, :longitude, :float
  end
end
