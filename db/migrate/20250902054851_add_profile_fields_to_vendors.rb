class AddProfileFieldsToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :profile_image, :string
    add_column :vendors, :bio, :text
    # add_column :vendors, :phone, :string
    add_column :vendors, :whatsapp, :string
    add_column :vendors, :banner_image, :string
  end
end
