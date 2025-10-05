# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_05_053059) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "food_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vendor_id"
    t.decimal "unit_price", precision: 10, scale: 2
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["food_id"], name: "index_cart_items_on_food_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.string "slug"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "categorizations", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categorizations_on_category_id"
    t.index ["food_id"], name: "index_categorizations_on_food_id"
  end

  create_table "conversation_participants", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "participant_type"
    t.index ["conversation_id"], name: "index_conversation_participants_on_conversation_id"
    t.index ["participant_id"], name: "index_conversation_participants_on_participant_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "vendor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["user_id"], name: "index_conversations_on_user_id"
    t.index ["vendor_id"], name: "index_conversations_on_vendor_id"
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_categories", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_food_categories_on_category_id"
    t.index ["food_id"], name: "index_food_categories_on_food_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 8, scale: 2
    t.text "description"
    t.boolean "featured"
    t.string "slug"
    t.bigint "vendor_id"
    t.boolean "active"
    t.integer "stock"
    t.boolean "in_stock", default: true, null: false
    t.index ["slug"], name: "index_foods_on_slug", unique: true
    t.index ["vendor_id"], name: "index_foods_on_vendor_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "sender_user_id"
    t.bigint "sender_vendor_id"
    t.text "body", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id"
    t.string "sender_type"
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.boolean "delivered", default: false, null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["recipient_type", "recipient_id"], name: "index_messages_on_recipient"
    t.index ["sender_user_id"], name: "index_messages_on_sender_user_id"
    t.index ["sender_vendor_id"], name: "index_messages_on_sender_vendor_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_notifications_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "food_id", null: false
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "vendor_id", null: false
    t.decimal "platform_commission", precision: 10, scale: 2, default: "0.0"
    t.decimal "vendor_earnings", precision: 10, scale: 2, default: "0.0"
    t.decimal "subtotal", precision: 10, scale: 2
    t.index ["food_id"], name: "index_order_items_on_food_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["vendor_id"], name: "index_order_items_on_vendor_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "payment_reference"
    t.boolean "seen_by_admin"
    t.boolean "pay_on_delivery"
    t.integer "status", default: 0
    t.bigint "cart_id"
    t.string "order_number"
    t.datetime "estimated_delivery_time"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "badge"
    t.boolean "active"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cta_text"
    t.string "cta_url"
    t.bigint "vendor_id"
    t.bigint "food_id"
    t.index ["food_id"], name: "index_promotions_on_food_id"
    t.index ["vendor_id"], name: "index_promotions_on_vendor_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.integer "rating"
    t.bigint "food_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "comment"
    t.index ["food_id"], name: "index_reviews_on_food_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.string "subject"
    t.text "body"
    t.string "status", default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_support_tickets_on_order_id"
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "testimonials", force: :cascade do |t|
    t.string "name"
    t.text "comment"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.datetime "deleted_at"
    t.integer "role", default: 0, null: false
    t.datetime "last_seen_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  create_table "vendor_earnings", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "order_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.datetime "paid_at"
    t.bigint "order_item_id", null: false
    t.index ["order_id"], name: "index_vendor_earnings_on_order_id"
    t.index ["order_item_id"], name: "index_vendor_earnings_on_order_item_id"
    t.index ["vendor_id"], name: "index_vendor_earnings_on_vendor_id"
  end

  create_table "vendor_reviews", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vendor_reviews_on_user_id"
    t.index ["vendor_id"], name: "index_vendor_reviews_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "phone"
    t.string "address"
    t.decimal "commission_rate", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.text "bio"
    t.string "whatsapp"
    t.string "bank_name"
    t.string "account_name"
    t.string "account_number"
    t.string "payout_method"
    t.string "transfer_recipient_code"
    t.string "contact_person"
    t.string "business_type"
    t.string "city"
    t.string "opening_hours"
    t.string "cac_number"
    t.string "state"
    t.integer "status", default: 0, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "last_seen_at"
    t.text "description"
    t.string "slug"
    t.boolean "seed_data", default: false, null: false
    t.boolean "terms_accepted"
    t.index ["email"], name: "index_vendors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_vendors_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_vendors_on_slug", unique: true
    t.index ["unlock_token"], name: "index_vendors_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "foods"
  add_foreign_key "carts", "users", on_delete: :cascade
  add_foreign_key "categorizations", "categories"
  add_foreign_key "categorizations", "foods"
  add_foreign_key "conversation_participants", "conversations"
  add_foreign_key "conversation_participants", "users", column: "participant_id"
  add_foreign_key "conversations", "users"
  add_foreign_key "conversations", "vendors"
  add_foreign_key "food_categories", "categories"
  add_foreign_key "food_categories", "foods"
  add_foreign_key "foods", "vendors"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "sender_user_id"
  add_foreign_key "messages", "vendors", column: "sender_vendor_id"
  add_foreign_key "notifications", "orders"
  add_foreign_key "order_items", "foods"
  add_foreign_key "order_items", "orders", on_delete: :cascade
  add_foreign_key "order_items", "vendors"
  add_foreign_key "orders", "carts"
  add_foreign_key "orders", "users", on_delete: :cascade
  add_foreign_key "promotions", "foods"
  add_foreign_key "promotions", "vendors"
  add_foreign_key "reviews", "foods"
  add_foreign_key "reviews", "users"
  add_foreign_key "support_tickets", "orders"
  add_foreign_key "support_tickets", "users"
  add_foreign_key "vendor_earnings", "order_items"
  add_foreign_key "vendor_earnings", "orders"
  add_foreign_key "vendor_earnings", "vendors"
  add_foreign_key "vendor_reviews", "users"
  add_foreign_key "vendor_reviews", "vendors"
end
