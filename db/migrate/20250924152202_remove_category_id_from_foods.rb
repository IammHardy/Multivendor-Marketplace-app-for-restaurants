class RemoveCategoryIdFromFoods < ActiveRecord::Migration[8.0]
  def change
    remove_column :foods, :category_id, :integer
  end
end
