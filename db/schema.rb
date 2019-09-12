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

ActiveRecord::Schema.define(version: 2019_04_26_080447) do

  create_table "alternate_server_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "alternate_server_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.text "description"
    t.text "replacement_explanation"
    t.index ["alternate_server_id"], name: "index_alternate_server_translations_on_alternate_server_id"
    t.index ["locale"], name: "index_alternate_server_translations_on_locale"
  end

  create_table "alternate_servers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.integer "creator_id", null: false
    t.integer "modifier_id", null: false
    t.timestamp "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "replacement_url"
    t.index ["creator_id"], name: "index_alternate_servers_on_creator_id"
    t.index ["deleted_at"], name: "index_alternate_servers_on_deleted_at"
    t.index ["modifier_id"], name: "index_alternate_servers_on_modifier_id"
  end

  create_table "application_settings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "setting_key", null: false
    t.string "setting_value", null: false
  end

  create_table "article_images", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "source_url"
    t.string "original_basename"
    t.string "original_extname"
    t.string "mime_type"
    t.binary "image_data"
    t.string "article_id", limit: 36, null: false
    t.integer "article_source_id", null: false
    t.integer "creator_id"
    t.integer "modifier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "index_article_images_on_article_id"
    t.index ["article_source_id"], name: "index_article_images_on_article_source_id"
    t.index ["creator_id"], name: "index_article_images_on_creator_id"
    t.index ["modifier_id"], name: "index_article_images_on_modifier_id"
  end

  create_table "article_sources", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_article_sources_on_name", unique: true
  end

  create_table "articles", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "barcode"
    t.string "name", null: false
    t.integer "article_source_id", null: false
    t.integer "creator_id"
    t.integer "modifier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "producer_id"
    t.index ["article_source_id"], name: "index_articles_on_article_source_id"
    t.index ["barcode"], name: "index_articles_on_barcode"
    t.index ["created_at"], name: "index_articles_on_created_at"
    t.index ["creator_id", "barcode"], name: "index_articles_on_creator_id_and_barcode", unique: true
    t.index ["creator_id"], name: "index_articles_on_creator_id"
    t.index ["modifier_id"], name: "index_articles_on_modifier_id"
    t.index ["producer_id"], name: "index_articles_on_producer_id"
    t.index ["updated_at"], name: "index_articles_on_updated_at"
  end

  create_table "impressions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 255 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "locations", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "creator_id", null: false
    t.integer "modifier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["created_at"], name: "index_locations_on_created_at"
    t.index ["creator_id"], name: "index_locations_on_creator_id"
    t.index ["modifier_id"], name: "index_locations_on_modifier_id"
    t.index ["updated_at"], name: "index_locations_on_updated_at"
  end

  create_table "locations_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "location_id", limit: 36, null: false
    t.integer "user_id"
    t.index ["location_id", "user_id"], name: "index_locations_users_on_location_id_and_user_id"
    t.index ["user_id", "location_id"], name: "index_locations_users_on_user_id_and_location_id", unique: true
    t.index ["user_id"], name: "index_locations_users_on_user_id"
  end

  create_table "producers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "creator_id"
    t.integer "modifier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["creator_id"], name: "index_producers_on_creator_id"
    t.index ["modifier_id"], name: "index_producers_on_modifier_id"
    t.index ["name"], name: "index_producers_on_name", unique: true
  end

  create_table "product_entries", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.integer "amount", null: false
    t.date "expiration_date"
    t.string "article_id", limit: 36, null: false
    t.integer "creator_id", null: false
    t.integer "modifier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location_id", limit: 36, null: false
    t.datetime "deleted_at"
    t.boolean "free_to_take", default: false, null: false
    t.index ["article_id"], name: "index_product_entries_on_article_id"
    t.index ["created_at"], name: "index_product_entries_on_created_at"
    t.index ["creator_id"], name: "index_product_entries_on_creator_id"
    t.index ["expiration_date"], name: "index_product_entries_on_expiration_date"
    t.index ["location_id"], name: "index_product_entries_on_location_id"
    t.index ["modifier_id"], name: "index_product_entries_on_modifier_id"
    t.index ["updated_at"], name: "index_product_entries_on_updated_at"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.binary "username", limit: 255, default: "", null: false
    t.string "email"
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
    t.datetime "deleted_at"
    t.boolean "creating_to_accept_share", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
