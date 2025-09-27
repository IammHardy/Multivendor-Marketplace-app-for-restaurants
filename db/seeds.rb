puts "🌱 Resetting database..."

# --- CLEANUP (order matters due to foreign keys) ---
CartItem.destroy_all
OrderItem.destroy_all if defined?(OrderItem)
Conversation.destroy_all if defined?(Conversation)

Promotion.destroy_all
Food.destroy_all
Vendor.destroy_all
Testimonial.destroy_all
Category.destroy_all

puts "✅ Old data removed."

# =========================================
#            SEED CATEGORIES
# =========================================
puts "🌱 Seeding categories..."

meals       = Category.create!(name: "Meals")
small_chops = Category.create!(name: "Small Chops & Sides")
drinks      = Category.create!(name: "Drinks")
desserts    = Category.create!(name: "Desserts")

{
  meals => ["Rice Dishes", "Swallows & Soups", "Pasta & Noodles", "Proteins", "Specials"],
  small_chops => ["Finger Foods", "Grills & BBQ", "Sides"],
  drinks => ["Soft Drinks", "Juices", "Smoothies", "Water", "Alcoholic Drinks"],
  desserts => ["Cakes", "Pastries", "Ice Cream"]
}.each do |parent, subs|
  subs.each do |sub|
    Category.create!(name: sub, parent: parent)
  end
end

puts "✅ Categories created."

# =========================================
#            SEED VENDORS
# =========================================
puts "🌱 Seeding vendors..."

sajuma = Vendor.create!(
  name: "Sajuma",
  email: "sajuma@example.com",
  password: "password123",
  contact_person: "Mr. Sajuma",
  phone: "+2348012345678",
  address: "123 Food Street, Abuja",
  city: "Abuja",
  description: "Famous for tasty Jollof and local dishes"
)

kilimanjaro = Vendor.create!(
  name: "Kilimanjaro",
  email: "kilimanjaro@example.com",
  password: "password123",
  contact_person: "Manager Kili",
  phone: "+2348098765432",
  address: "45 Quick Meal Ave, Lagos",
  city: "Lagos",
  description: "Popular quick-service meals and snacks"
)

peak_light = Vendor.create!(
  name: "Peak & Light",
  email: "peaklight@example.com",
  password: "password123",
  contact_person: "Miss Light",
  phone: "+2348087654321",
  address: "22 Healthy Way, PH",
  city: "Port Harcourt",
  description: "Healthy meals and salads for your day"
)

puts "✅ Vendors created."

# =========================================
#            SEED FOODS
# =========================================
puts "🌱 Seeding foods..."

jollof = sajuma.foods.create!(
  name: "Jollof Rice",
  price: 2500
)

burger = kilimanjaro.foods.create!(
  name: "Beef Burger",
  price: 3500
)

salad = peak_light.foods.create!(
  name: "Chicken Salad",
  price: 4000
)

puts "✅ Foods created."

# =========================================
#            SEED PROMOTIONS
# =========================================
puts "🌱 Seeding promotions..."

default_promo_image = Rails.root.join("app/assets/images/default-promo.jpg")

promo1 = Promotion.create!(
  title: "10% Off Jollof Rice",
  description: "Get a tasty deal on Sajuma’s classic Jollof Rice.",
  badge: "10% Off",
  vendor: sajuma,
  food: jollof,
  active: true,
  starts_at: Time.current,
  ends_at: 1.month.from_now,
  cta_text: "Order Now",
  cta_url: "/vendors/#{sajuma.id}/foods/#{jollof.id}"
)

promo2 = Promotion.create!(
  title: "Free Delivery on Burgers",
  description: "Enjoy free delivery on all burgers from Kilimanjaro this weekend.",
  badge: "Free Delivery",
  vendor: kilimanjaro,
  food: burger,
  active: true,
  starts_at: Time.current,
  ends_at: 2.weeks.from_now,
  cta_text: "Order Now",
  cta_url: "/vendors/#{kilimanjaro.id}/foods/#{burger.id}"
)

promo3 = Promotion.create!(
  title: "Healthy Start Deal",
  description: "Kickstart your day with Peak & Light’s Chicken Salad at a discount.",
  badge: "Special",
  vendor: peak_light,
  food: salad,
  active: true,
  starts_at: Time.current,
  ends_at: 1.month.from_now,
  cta_text: "Order Now",
  cta_url: "/vendors/#{peak_light.id}/foods/#{salad.id}"
)

[promo1, promo2, promo3].each do |promo|
  if File.exist?(default_promo_image)
    promo.image.attach(
      io: File.open(default_promo_image),
      filename: "default-promo.jpg",
      content_type: "image/jpeg"
    )
  end
end

puts "✅ Promotions created."

# =========================================
#            TESTIMONIALS
# =========================================
puts "🌱 Seeding testimonials..."

Testimonial.create!([
  {
    name: "Amaka Okafor",
    comment: "The best food delivery experience I've ever had! Quick and fresh.",
    rating: 5,
    approved: true
  },
  {
    name: "Chinedu Obi",
    comment: "I love how easy it is to find my favorite local dishes. Highly recommend!",
    rating: 4,
    approved: true
  },
  {
    name: "Fatima Bello",
    comment: "Affordable, fast, and delicious. This app makes life so much easier!",
    rating: 5,
    approved: true
  }
])

puts "✅ Testimonials created."
puts "🌱 Seeding complete!"
