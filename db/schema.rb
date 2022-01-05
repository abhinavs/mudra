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

ActiveRecord::Schema.define(version: 2022_01_03_132903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string "name", limit: 30
    t.text "description"
    t.string "guid", limit: 30
    t.string "api_key", limit: 50
    t.string "status", limit: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["api_key"], name: "index_apps_on_api_key", unique: true
    t.index ["guid"], name: "index_apps_on_guid"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "app_id"
    t.integer "user_id"
    t.string "transaction_type", limit: 10
    t.float "amount"
    t.float "updated_balance"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_id"], name: "index_transactions_on_app_id"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "app_id"
    t.string "user_uid", limit: 30
    t.float "current_balance", default: 0.0
    t.string "status", limit: 20
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_id"], name: "index_users_on_app_id"
    t.index ["user_uid"], name: "index_users_on_user_uid"
  end

end
