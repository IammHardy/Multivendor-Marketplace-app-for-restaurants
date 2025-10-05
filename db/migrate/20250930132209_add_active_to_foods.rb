class AddActiveToFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :active, :boolean
  end
end
