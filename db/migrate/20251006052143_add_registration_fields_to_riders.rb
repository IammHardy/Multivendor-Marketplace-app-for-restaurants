class AddRegistrationFieldsToRiders < ActiveRecord::Migration[8.0]
  def change
    add_column :riders, :address, :string
    add_column :riders, :city, :string
    add_column :riders, :state, :string
    add_column :riders, :license_plate, :string
    add_column :riders, :national_id, :string
    add_column :riders, :validation_step, :integer, default: 1
    add_column :riders, :terms_accepted, :boolean, default: false
    add_column :riders, :status_enum, :integer, default: 0
  end
end
