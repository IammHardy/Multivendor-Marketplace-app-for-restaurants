class AddStockToFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :stock, :integer, :default => 0
  end
end
