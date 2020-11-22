# encoding: UTF-8
# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20170308163825) do
  create_table 'collaborators', force: :cascade do |t|
    t.integer  'project_id', limit: 4
    t.string   'login',      limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'collaborators', ['project_id'], name: 'index_collaborators_on_project_id', using: :btree

  create_table 'deposits', force: :cascade do |t|
    t.integer  'project_id',    limit: 4
    t.string   'txid',          limit: 255
    t.integer  'confirmations', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer  'amount',        limit: 8
    t.float    'fee_size',      limit: 24
  end

  add_index 'deposits', ['project_id'], name: 'index_deposits_on_project_id', using: :btree

  create_table 'projects', force: :cascade do |t|
    t.string   'url',                    limit: 255
    t.string   'bitcoin_address',        limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'name',                   limit: 255
    t.string   'full_name',              limit: 255
    t.string   'source_full_name',       limit: 255
    t.text     'description',            limit: 65535
    t.integer  'watchers_count',         limit: 4
    t.string   'language',               limit: 255
    t.string   'last_commit',            limit: 255
    t.integer  'available_amount_cache', limit: 4
    t.string   'github_id',              limit: 255
    t.string   'host',                   limit: 255,   default: 'github'
    t.boolean  'hold_tips',                            default: false
    t.datetime 'info_updated_at'
    t.string   'branch', limit: 255
    t.boolean  'disable_notifications'
    t.string   'avatar_url', limit: 255
    t.datetime 'deleted_at'
    t.string   'bitcoin_address2',       limit: 255
    t.integer  'wallet_id',              limit: 4
    t.string   'legacy_address',         limit: 255
  end

  add_index 'projects', ['full_name'], name: 'index_projects_on_full_name', unique: true, using: :btree
  add_index 'projects', ['github_id'], name: 'index_projects_on_github_id', unique: true, using: :btree

  create_table 'sendmanies', force: :cascade do |t|
    t.string   'txid',       limit: 255
    t.text     'data',       limit: 65535
    t.string   'result',     limit: 255
    t.boolean  'is_error'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'tipping_policies_texts', force: :cascade do |t|
    t.integer  'project_id', limit: 4
    t.integer  'user_id',    limit: 4
    t.text     'text',       limit: 65535
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'tipping_policies_texts', ['project_id'], name: 'index_tipping_policies_texts_on_project_id', using: :btree
  add_index 'tipping_policies_texts', ['user_id'], name: 'index_tipping_policies_texts_on_user_id', using: :btree

  create_table 'tips', force: :cascade do |t|
    t.integer  'user_id',        limit: 4
    t.integer  'amount',         limit: 8
    t.integer  'sendmany_id',    limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'commit',         limit: 255
    t.integer  'project_id',     limit: 4
    t.datetime 'refunded_at'
    t.text     'commit_message', limit: 65535
    t.datetime 'decided_at'
  end

  add_index 'tips', ['project_id'], name: 'index_tips_on_project_id', using: :btree
  add_index 'tips', ['sendmany_id'], name: 'index_tips_on_sendmany_id', using: :btree
  add_index 'tips', ['user_id'], name: 'index_tips_on_user_id', using: :btree

  create_table 'users', force: :cascade do |t|
    t.string   'email',                  limit: 255, default: '', null: false
    t.string   'encrypted_password',     limit: 255, default: '', null: false
    t.string   'reset_password_token',   limit: 255
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', limit: 4, default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip',     limit: 255
    t.string   'last_sign_in_ip',        limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string   'nickname',               limit: 255
    t.string   'name',                   limit: 255
    t.string   'image',                  limit: 255
    t.string   'bitcoin_address',        limit: 255
    t.string   'login_token',            limit: 255
    t.boolean  'unsubscribed'
    t.datetime 'notified_at'
    t.integer  'commits_count',          limit: 4,   default: 0
    t.integer  'withdrawn_amount',       limit: 8,   default: 0
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string   'confirmation_token',     limit: 255
    t.string   'unconfirmed_email',      limit: 255
    t.string   'display_name',           limit: 255
    t.integer  'denom',                  limit: 4, default: 0
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree

  create_table 'wallets', force: :cascade do |t|
    t.string   'name',               limit: 255
    t.string   'xpub',               limit: 255
    t.integer  'last_address_index', limit: 4, default: 1
    t.datetime 'created_at',                                 null: false
    t.datetime 'updated_at',                                 null: false
  end
end
