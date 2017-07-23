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

ActiveRecord::Schema.define(version: 20170703201819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "category"
    t.string   "number"
    t.integer  "popularity"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "password_digest"
    t.float    "bedroom_mult"
    t.float    "dining_mult"
    t.float    "seating_mult"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
