class AddVendorToFoods < ActiveRecord::Migration[8.0]
  def change
    add_reference :foods, :vendor, foreign_key: true
  end
end
