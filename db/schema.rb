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

ActiveRecord::Schema[8.0].define(version: 2026_01_14_044653) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "external_customer_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "tax_number"
    t.text "address"
    t.string "cid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number"
    t.bigint "customer_id", null: false
    t.date "issue_date", default: -> { "CURRENT_DATE" }
    t.string "status", default: "draft"
    t.string "currency", default: "BTN"
    t.decimal "subtotal"
    t.decimal "tax_total"
    t.decimal "grand_total"
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_invoices_on_created_by_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "external_transaction_ref"
    t.bigint "invoice_id", null: false
    t.bigint "customer_id", null: false
    t.date "transaction_date"
    t.decimal "amount"
    t.decimal "tax_amount"
    t.string "currency", default: "BTN"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_transactions_on_customer_id"
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "email"
    t.string "password"
    t.string "branch"
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "users", column: "created_by_id"
  add_foreign_key "transactions", "customers"
  add_foreign_key "transactions", "invoices"
  add_foreign_key "users", "roles"
end
