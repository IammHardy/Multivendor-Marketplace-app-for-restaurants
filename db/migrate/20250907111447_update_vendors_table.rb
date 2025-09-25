class UpdateVendorsTable < ActiveRecord::Migration[8.0]
  def change
    change_table :vendors, bulk: true do |t|
      # Business / KYC fields
     
      

      # Status for vendor lifecycle
      # t.integer :status, default: 0, null: false
    end

    # === Indexes ===
    
  end
end
