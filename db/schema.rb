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

ActiveRecord::Schema.define(version: 20141017032753) do

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "isAdmin",         default: false
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true

  create_table "group_memberships", force: true do |t|
    t.integer  "employee_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["employee_id", "group_id"], name: "index_group_memberships_on_employee_id_and_group_id", unique: true
  add_index "group_memberships", ["employee_id"], name: "index_group_memberships_on_employee_id"
  add_index "group_memberships", ["group_id"], name: "index_group_memberships_on_group_id"

  create_table "group_ownerships", force: true do |t|
    t.integer  "employee_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_ownerships", ["employee_id"], name: "index_group_ownerships_on_employee_id"
  add_index "group_ownerships", ["group_id"], name: "index_group_ownerships_on_group_id", unique: true

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
