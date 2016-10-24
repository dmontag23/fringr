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

ActiveRecord::Schema.define(version: 20161024193428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
  end

  create_table "days", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "schedule_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["schedule_id"], name: "index_days_on_schedule_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id", using: :btree
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "piece_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_participants_on_contact_id", using: :btree
    t.index ["piece_id"], name: "index_participants_on_piece_id", using: :btree
  end

  create_table "pieces", force: :cascade do |t|
    t.string   "title"
    t.integer  "length"
    t.integer  "setup"
    t.integer  "cleanup"
    t.integer  "location_id"
    t.integer  "rating"
    t.integer  "day_id"
    t.integer  "start_time"
    t.integer  "schedule_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["day_id"], name: "index_pieces_on_day_id", using: :btree
    t.index ["location_id"], name: "index_pieces_on_location_id", using: :btree
    t.index ["schedule_id"], name: "index_pieces_on_schedule_id", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.string   "name"
    t.integer  "actor_transition_time"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["user_id"], name: "index_schedules_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "days", "schedules"
  add_foreign_key "locations", "users"
  add_foreign_key "participants", "contacts"
  add_foreign_key "participants", "pieces"
  add_foreign_key "pieces", "days"
  add_foreign_key "pieces", "locations"
  add_foreign_key "pieces", "schedules"
  add_foreign_key "schedules", "users"
end
