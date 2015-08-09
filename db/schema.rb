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

ActiveRecord::Schema.define(version: 20150809162520) do

  create_table "article_images", force: true do |t|
    t.string   "source_url"
    t.string   "original_basename"
    t.string   "original_extname"
    t.string   "mime_type"
    t.binary   "image_data"
    t.integer  "article_id",        null: false
    t.integer  "article_source_id", null: false
    t.integer  "creator_id",        null: false
    t.integer  "modifier_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_images", ["article_id"], name: "index_article_images_on_article_id"
  add_index "article_images", ["article_source_id"], name: "index_article_images_on_article_source_id"
  add_index "article_images", ["creator_id"], name: "index_article_images_on_creator_id"
  add_index "article_images", ["modifier_id"], name: "index_article_images_on_modifier_id"

  create_table "article_sources", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "article_sources", ["name"], name: "index_article_sources_on_name", unique: true

  create_table "articles", force: true do |t|
    t.string   "name",              null: false
    t.integer  "article_source_id", null: false
    t.integer  "creator_id",        null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "barcode",           null: false
    t.integer  "modifier_id",       null: false
    t.integer  "producer_id"
  end

  add_index "articles", ["article_source_id"], name: "index_articles_on_article_source_id"
  add_index "articles", ["barcode"], name: "index_articles_on_barcode"
  add_index "articles", ["created_at"], name: "index_articles_on_created_at"
  add_index "articles", ["creator_id", "barcode"], name: "index_articles_on_creator_id_and_barcode", unique: true
  add_index "articles", ["creator_id"], name: "index_articles_on_creator_id"
  add_index "articles", ["modifier_id"], name: "index_articles_on_modifier_id"
  add_index "articles", ["producer_id"], name: "index_articles_on_producer_id"
  add_index "articles", ["updated_at"], name: "index_articles_on_updated_at"

  create_table "locations", force: true do |t|
    t.string   "name",        null: false
    t.integer  "creator_id",  null: false
    t.integer  "modifier_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
  end

  add_index "locations", ["created_at"], name: "index_locations_on_created_at"
  add_index "locations", ["creator_id", "name"], name: "index_locations_on_creator_id_and_name", unique: true
  add_index "locations", ["creator_id"], name: "index_locations_on_creator_id"
  add_index "locations", ["modifier_id"], name: "index_locations_on_modifier_id"
  add_index "locations", ["updated_at"], name: "index_locations_on_updated_at"

  create_table "locations_users", id: false, force: true do |t|
    t.integer "location_id"
    t.integer "user_id"
  end

  add_index "locations_users", ["location_id", "user_id"], name: "index_locations_users_on_location_id_and_user_id"
  add_index "locations_users", ["user_id"], name: "index_locations_users_on_user_id"

  create_table "producers", force: true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.integer  "modifier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "producers", ["creator_id"], name: "index_producers_on_creator_id"
  add_index "producers", ["modifier_id"], name: "index_producers_on_modifier_id"
  add_index "producers", ["name"], name: "index_producers_on_name", unique: true

  create_table "product_entries", force: true do |t|
    t.string   "description"
    t.integer  "amount",          null: false
    t.date     "expiration_date"
    t.integer  "article_id",      null: false
    t.integer  "creator_id",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "modifier_id",     null: false
    t.integer  "location_id",     null: false
    t.datetime "deleted_at"
  end

  add_index "product_entries", ["article_id"], name: "index_product_entries_on_article_id"
  add_index "product_entries", ["created_at"], name: "index_product_entries_on_created_at"
  add_index "product_entries", ["creator_id"], name: "index_product_entries_on_creator_id"
  add_index "product_entries", ["expiration_date"], name: "index_product_entries_on_expiration_date"
  add_index "product_entries", ["location_id"], name: "index_product_entries_on_location_id"
  add_index "product_entries", ["modifier_id"], name: "index_product_entries_on_modifier_id"
  add_index "product_entries", ["updated_at"], name: "index_product_entries_on_updated_at"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
