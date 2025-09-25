class AssignDefaultVendorToFoods < ActiveRecord::Migration[7.0]
  def up
    # 1️⃣ Get or create a default vendor
    default_vendor = Vendor.find_or_create_by!(name: "Default Vendor") do |vendor|
      vendor.email = "default_vendor@example.com"
      vendor.password = SecureRandom.hex(8) # set a random password
    end

    # 2️⃣ Assign vendor_id to all foods that are missing it
    Food.where(vendor_id: nil).update_all(vendor_id: default_vendor.id)
  end

  def down
    # Rollback: set vendor_id to nil again
    Food.where(vendor_id: Vendor.find_by(name: "Default Vendor")&.id).update_all(vendor_id: nil)
  end
end
