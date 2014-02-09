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

ActiveRecord::Schema.define(version: 20140209041123) do

  create_table "deposits", force: true do |t|
    t.integer  "project_id"
    t.string   "txid"
    t.integer  "confirmations"
    t.integer  "duration",                default: 2592000
    t.integer  "paid_out",      limit: 8
    t.datetime "paid_out_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount",        limit: 8
  end

  add_index "deposits", ["project_id"], name: "index_deposits_on_project_id"

  create_table "projects", force: true do |t|
    t.string   "url"
    t.string   "bitcoin_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "full_name"
    t.string   "source_full_name"
    t.text     "description"
    t.integer  "watchers_count"
    t.string   "language"
    t.string   "last_commit"
    t.integer  "available_amount_cache"
    t.string   "github_id"
  end

  add_index "projects", ["full_name"], name: "index_projects_on_full_name", unique: true
  add_index "projects", ["github_id"], name: "index_projects_on_github_id", unique: true

  create_table "sendmanies", force: true do |t|
    t.string   "txid"
    t.text     "data"
    t.string   "result"
    t.boolean  "is_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount",      limit: 8
    t.integer  "sendmany_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commit"
    t.integer  "project_id"
    t.datetime "refunded_at"
  end

  add_index "tips", ["project_id"], name: "index_tips_on_project_id"
  add_index "tips", ["sendmany_id"], name: "index_tips_on_sendmany_id"
  add_index "tips", ["user_id"], name: "index_tips_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname"
    t.string   "name"
    t.string   "image"
    t.string   "bitcoin_address"
    t.string   "login_token"
    t.boolean  "unsubscribed"
    t.datetime "notified_at"
    t.integer  "commits_count",                    default: 0
    t.integer  "withdrawn_amount",       limit: 8, default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
