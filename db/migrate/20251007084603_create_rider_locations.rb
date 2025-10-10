class CreateRiderLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :rider_locations do |t|
      t.references :rider, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
