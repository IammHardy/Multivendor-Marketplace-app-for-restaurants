puts "🌱 Seeding database..."

# --- MAIN CATEGORIES ---
meals       = Category.find_or_create_by!(name: "Meals")
small_chops = Category.find_or_create_by!(name: "Small Chops & Sides")
drinks      = Category.find_or_create_by!(name: "Drinks")
desserts    = Category.find_or_create_by!(name: "Desserts")

# --- SUBCATEGORIES ---
{
  meals => ["Rice Dishes", "Swallows & Soups", "Pasta & Noodles", "Proteins", "Specials"],
  small_chops => ["Finger Foods", "Grills & BBQ", "Sides"],
  drinks => ["Soft Drinks", "Juices", "Smoothies", "Water", "Alcoholic Drinks"],
  desserts => ["Cakes", "Pastries", "Ice Cream"]
}.each do |parent, subs|
  subs.each do |sub|
    Category.find_or_create_by!(name: sub, parent: parent)
  end
end

# --- SAMPLE VENDORS ---
vendors = [
  { 
    name: "Mama Put", 
    business_type: "Restaurant",
    email: "mamaput@example.com",
    password: "password123",
    contact_person: "Mama Esther",
    phone: "+2348012345678",
    address: "123 Food Street, Abuja",
    city: "Abuja",
    profile_image: "mamaput_logo.jpg"
  },
  { 
    name: "Grill Master", 
    business_type: "BBQ",
    email: "grillmaster@example.com",
    password: "password123",
    contact_person: "Mr. Grill",
    phone: "+2348098765432",
    address: "45 BBQ Lane, Lagos",
    city: "Lagos",
    profile_image: "grillmaster_logo.jpg"
  },
  { 
    name: "Cool Drinks NG", 
    business_type: "Beverages",
    email: "cooldrinks@example.com",
    password: "password123",
    contact_person: "Miss Ada",
    phone: "+2348087654321",
    address: "22 Refresh Road, Port Harcourt",
    city: "Port Harcourt",
    profile_image: "cooldrinks_logo.jpg"
  }
]

vendors.each do |v|
  vendor = Vendor.find_or_create_by!(email: v[:email]) do |ven|
    ven.name           = v[:name]
    ven.business_type  = v[:business_type]
    ven.password       = v[:password]
    ven.contact_person = v[:contact_person]
    ven.phone          = v[:phone]
    ven.address        = v[:address]
    ven.city           = v[:city]
  end

  # Attach profile image if exists
  if v[:profile_image].present? && !vendor.profile_image.attached?
    path = Rails.root.join("db/seed_images/#{v[:profile_image]}")
    if File.exist?(path)
      vendor.profile_image.attach(
        io: File.open(path),
        filename: v[:profile_image],
        content_type: "image/jpg"
      )
    end
  end
end

# --- SAMPLE FOODS ---
sample_foods = [
  { 
    name: "Jollof Rice", 
    price: 100, 
    category: Category.find_by(name: "Rice Dishes"), 
    vendor: Vendor.find_by(email: "mamaput@example.com"), 
    image: "jollof_rice.jpg" 
  },
  { 
    name: "Suya", 
    price: 1000, 
    category: Category.find_by(name: "Grills & BBQ"), 
    vendor: Vendor.find_by(email: "grillmaster@example.com"), 
    image: "suya.jpg" 
  },
  { 
    name: "Pepsi", 
    price: 500, 
    category: Category.find_by(name: "Soft Drinks"), 
    vendor: Vendor.find_by(email: "cooldrinks@example.com"), 
    image: "pepsi.jpg" 
  }
]

sample_foods.each do |food|
  f = Food.find_or_create_by!(name: food[:name], vendor: food[:vendor]) do |fd|
    fd.price = food[:price]
    fd.category = food[:category] # single category per food
  end

  # Attach food image if exists
  if food[:image].present? && !f.image.attached?
    path = Rails.root.join("db/seed_images/#{food[:image]}")
    if File.exist?(path)
      f.image.attach(
        io: File.open(path),
        filename: food[:image],
        content_type: "image/jpg"
      )
    end
  end
end

puts "✅ Seeding completed!"

# db/seeds.rb

puts "Seeding default admin..."

admin_email = "abdulhadiyusuf842@gmail.com"
admin_password = "123456!!" # change if needed

admin = User.find_or_initialize_by(email: admin_email)
admin.assign_attributes(
  password: admin_password,
  password_confirmation: admin_password,
  confirmed_at: Time.current,
  role: :admin
)
if admin.new_record? || admin.changed?
  admin.save!
  puts "✅ Admin created/updated: #{admin_email}"
else
  puts "ℹ️ Admin already exists: #{admin_email}"
end

# db/seeds.rb
vendor = Vendor.first

vendor.foods.create([
  { name: "Jollof Rice", description: "Spicy Nigerian rice with tomatoes", price: 5.0 },
  { name: "Egusi Soup", description: "Traditional Nigerian melon seed soup", price: 7.0 },
  { name: "Suya", description: "Spicy grilled meat skewers", price: 3.5 },
  { name: "Fried Plantain", description: "Sweet fried plantain slices", price: 2.0 }
])

