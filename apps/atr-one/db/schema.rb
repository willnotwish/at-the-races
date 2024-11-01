# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20241031105353) do

  create_table "counter_updates", force: :cascade do |t|
    t.string   "counter_code", limit: 255
    t.string   "month_code",   limit: 255
    t.integer  "value",        limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "counters", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.integer  "value",      limit: 4,   default: 0
    t.integer  "month_id",   limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "counters", ["month_id"], name: "index_counters_on_month_id", using: :btree

  create_table "months", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "months", ["code"], name: "index_months_on_code", length: {"code"=>191}, using: :btree

  create_table "race_configs", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
    t.integer  "thread_count", limit: 4
    t.integer  "race_delay",   limit: 4
    t.integer  "lock_timeout", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "race_results", force: :cascade do |t|
    t.integer  "race_id",       limit: 4
    t.datetime "started_at"
    t.float    "duration",      limit: 24
    t.integer  "counter_count", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "race_results", ["race_id"], name: "index_race_results_on_race_id", using: :btree

  create_table "races", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
    t.integer  "race_delay",   limit: 4
    t.integer  "thread_count", limit: 4
    t.integer  "lock_timeout", limit: 4
    t.integer  "update_count", limit: 4
    t.string   "month_code",   limit: 255
    t.string   "counter_code", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_foreign_key "counters", "months"
  add_foreign_key "race_results", "races"
end
