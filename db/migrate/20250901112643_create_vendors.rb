class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.decimal :commission_rate, precision: 5, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
