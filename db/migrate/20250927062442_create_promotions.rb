class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.string :title
      t.text :description
      t.string :badge
      t.boolean :active
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
