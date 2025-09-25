class FixDeviseColumnsForVendors < ActiveRecord::Migration[8.0]
  def up
    change_column_default :vendors, :email, from: nil, to: ""
    change_column_default :vendors, :encrypted_password, from: nil, to: ""
  end

  def down
    change_column_default :vendors, :email, from: "", to: nil
    change_column_default :vendors, :encrypted_password, from: "", to: nil
  end
end
