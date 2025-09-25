class AddBusinessFieldsToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :contact_person, :string
    add_column :vendors, :business_type, :string
    add_column :vendors, :city, :string
    add_column :vendors, :opening_hours, :string
    add_column :vendors, :cac_number, :string
    add_column :vendors, :id_card, :string
  end
end
