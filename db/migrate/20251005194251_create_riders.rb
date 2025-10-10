class CreateRiders < ActiveRecord::Migration[8.0]
  def change
    create_table :riders do |t|
      t.string :name
      t.string :phone
      t.string :vehicle_type
      t.boolean :verified
      t.string :status
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
