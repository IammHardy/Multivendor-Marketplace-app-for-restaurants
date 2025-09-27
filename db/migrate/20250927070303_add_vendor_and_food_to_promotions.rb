class AddVendorAndFoodToPromotions < ActiveRecord::Migration[8.0]
  def change
    add_reference :promotions, :vendor, null: true, foreign_key: true
    add_reference :promotions, :food, null: true, foreign_key: true
  end
end
