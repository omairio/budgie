<<<<<<< HEAD
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

ActiveRecord::Schema.define(version: 20141008233623) do

  create_table "transactions", force: true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.string   "category"
    t.datetime "date"
    t.integer  "day_spread"
    t.float    "per_day"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "last_name"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
=======
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

ActiveRecord::Schema.define(version: 20141015042502) do

  create_table "transactions", force: true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.string   "category"
    t.datetime "date"
    t.integer  "day_spread"
    t.float    "per_day"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spread_type"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "last_name"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
>>>>>>> 52deff8b0c91346fa3d2745417a5f30e07894772
