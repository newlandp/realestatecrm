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

ActiveRecord::Schema.define(version: 20160531205914) do

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                             default: ""
    t.string   "email",                            default: ""
    t.integer  "phone_number",           limit: 8
    t.string   "address",                          default: ""
    t.integer  "days_between_contact",             default: 50
    t.datetime "last_contacted"
    t.integer  "beginning_days_between"
    t.boolean  "prior_relationship",               default: false
    t.text     "interests",                        default: ""
    t.text     "how_we_met",                       default: ""
    t.text     "notes",                            default: ""
    t.boolean  "hotlist",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "templates", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "task_description"
    t.boolean  "private",                 default: true
    t.string   "method_of_communication", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "templates", ["user_id"], name: "index_templates_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name",                   default: ""
    t.integer  "points",                 default: 0
    t.integer  "max_contacts_per_day",   default: 5
    t.string   "user_tasks",             default: ""
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
