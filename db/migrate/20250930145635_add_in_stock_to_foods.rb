class AddInStockToFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :in_stock, :boolean, default: true, null: false

    # If you want to migrate existing data:
    reversible do |dir|
      dir.up do
        Food.update_all(in_stock: true) # or false, depending on your current needs
      end
    end
  end
end
