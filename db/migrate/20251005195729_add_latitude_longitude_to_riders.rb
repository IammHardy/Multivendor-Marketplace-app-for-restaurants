class AddLatitudeLongitudeToRiders < ActiveRecord::Migration[8.0]
  def change
    add_column :riders, :latitude, :float unless column_exists?(:riders, :latitude)
    add_column :riders, :longitude, :float unless column_exists?(:riders, :longitude)
  end
end
