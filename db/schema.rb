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

ActiveRecord::Schema.define(version: 2017_03_08_163825) do

  create_table "collaborators", force: :cascade do |t|
    t.integer "project_id"
    t.string "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], name: "index_collaborators_on_project_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.integer "project_id"
    t.string "txid"
    t.integer "confirmations"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "amount", limit: 8
    t.float "fee_size"
    t.index ["project_id"], name: "index_deposits_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "url"
    t.string "bitcoin_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "full_name"
    t.string "source_full_name"
    t.text "description"
    t.integer "watchers_count"
    t.string "language"
    t.string "last_commit"
    t.integer "available_amount_cache"
    t.string "github_id"
    t.string "host", default: "github"
    t.boolean "hold_tips", default: false
    t.datetime "info_updated_at"
    t.string "branch"
    t.boolean "disable_notifications"
    t.string "avatar_url"
    t.datetime "deleted_at"
    t.string "bitcoin_address2"
    t.integer "wallet_id"
    t.string "legacy_address"
    t.index ["full_name"], name: "index_projects_on_full_name", unique: true
    t.index ["github_id"], name: "index_projects_on_github_id", unique: true
  end

  create_table "sendmanies", force: :cascade do |t|
    t.string "txid"
    t.text "data"
    t.string "result"
    t.boolean "is_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipping_policies_texts", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.text "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], name: "index_tipping_policies_texts_on_project_id"
    t.index ["user_id"], name: "index_tipping_policies_texts_on_user_id"
  end

  create_table "tips", force: :cascade do |t|
    t.integer "user_id"
    t.integer "amount", limit: 8
    t.integer "sendmany_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "commit"
    t.integer "project_id"
    t.datetime "refunded_at"
    t.text "commit_message"
    t.datetime "decided_at"
    t.index ["project_id"], name: "index_tips_on_project_id"
    t.index ["sendmany_id"], name: "index_tips_on_sendmany_id"
    t.index ["user_id"], name: "index_tips_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "nickname"
    t.string "name"
    t.string "image"
    t.string "bitcoin_address"
    t.string "login_token"
    t.boolean "unsubscribed"
    t.datetime "notified_at"
    t.integer "commits_count", default: 0
    t.integer "withdrawn_amount", limit: 8, default: 0
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string "unconfirmed_email"
    t.string "display_name"
    t.integer "denom", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "name"
    t.string "xpub"
    t.integer "last_address_index", limit: 4, default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
