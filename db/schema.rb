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

ActiveRecord::Schema.define(version: 20150319143528) do

  create_table "data_variable_values", force: :cascade do |t|
    t.integer  "data_variable_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_variables", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lorenz_data", force: :cascade do |t|
    t.decimal  "x_value",          precision: 3, scale: 2
    t.decimal  "y_value",          precision: 7, scale: 5
    t.decimal  "st_dev",           precision: 7, scale: 5
    t.integer  "data_variable_id"
    t.integer  "group_size"
    t.integer  "year"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "user_data", force: :cascade do |t|
    t.integer  "data_variable_id"
    t.integer  "user_id"
    t.integer  "year"
    t.decimal  "error_percent"
    t.decimal  "error"
    t.string   "value_string"
    t.decimal  "value_number_low"
    t.decimal  "value_number_high"
    t.decimal  "value_number_mid"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
