class EnsureVendorsHasStatus < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:vendors, :status)
      add_column :vendors, :status, :integer, default: 0, null: false
    end
  end
end
