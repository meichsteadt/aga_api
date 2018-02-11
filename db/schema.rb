# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180211230557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "discontinueds", force: :cascade do |t|
    t.string "number"
  end

  create_table "emails", force: :cascade do |t|
    t.string   "email_address"
    t.integer  "product_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.string   "product_number"
  end

  create_table "prices", force: :cascade do |t|
    t.string "number"
    t.float  "price"
  end

  create_table "product_items", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "number"
    t.integer  "price"
    t.string   "description"
    t.string   "dimensions"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "product_number"
    t.integer  "can_sell"
    t.date     "confirmed"
  end

  create_table "products", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "category"
    t.integer  "popularity"
    t.integer  "related_products", default: [],              array: true
    t.string   "images",           default: [],              array: true
    t.string   "thumbnail"
    t.float    "avg_price"
  end

  create_table "products_sub_categories", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "sub_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "parent_category"
    t.string   "thumbnail"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "password_digest"
    t.float    "bedroom_mult",    default: 2.2
    t.float    "dining_mult",     default: 2.2
    t.float    "seating_mult",    default: 2.2
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "auth_token"
    t.float    "youth_mult",      default: 2.2
    t.float    "occasional_mult", default: 2.2
    t.float    "home_mult",       default: 2.2
    t.string   "sort_by",         default: "price"
    t.boolean  "round",           default: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

end
