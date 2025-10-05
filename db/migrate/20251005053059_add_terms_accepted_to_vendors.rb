class AddTermsAcceptedToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :terms_accepted, :boolean
  end
end
