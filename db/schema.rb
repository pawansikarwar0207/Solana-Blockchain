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

ActiveRecord::Schema[7.1].define(version: 2025_06_02_081141) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "verification_product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["verification_product_id"], name: "index_order_items_on_verification_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status", default: "pending"
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_cents"
    t.string "payment_method"
    t.string "payment_memo"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_method"
    t.decimal "amount"
    t.string "solana_signature"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "provider_profiles", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "npi_number"
    t.string "license_number"
    t.string "state"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verification_status", default: "pending"
    t.text "failure_reason"
    t.index ["order_id"], name: "index_provider_profiles_on_order_id"
    t.index ["user_id"], name: "index_provider_profiles_on_user_id"
  end

  create_table "transaction_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "solana_tx"
    t.string "status"
    t.string "memo"
    t.bigint "order_id"
    t.decimal "amount"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "solana_wallet"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verification_products", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.decimal "price", precision: 12, scale: 6, default: "0.0"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verification_tasks", force: :cascade do |t|
    t.bigint "provider_profile_id", null: false
    t.bigint "verification_product_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_profile_id"], name: "index_verification_tasks_on_provider_profile_id"
    t.index ["verification_product_id"], name: "index_verification_tasks_on_verification_product_id"
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "verification_products"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "provider_profiles", "orders"
  add_foreign_key "provider_profiles", "users"
  add_foreign_key "verification_tasks", "provider_profiles"
  add_foreign_key "verification_tasks", "verification_products"
end
