class RemoveLegacyImageFieldsFromVendors < ActiveRecord::Migration[8.0]
  def change
    remove_column :vendors, :profile_image, :string
    remove_column :vendors, :banner_image, :string
    remove_column :vendors, :id_card, :string
  end
end
