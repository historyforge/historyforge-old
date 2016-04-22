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

ActiveRecord::Schema.define(version: 20160422212753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "architects", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "architects_buildings", id: false, force: :cascade do |t|
    t.integer "architect_id", null: false
    t.integer "building_id",  null: false
  end

  add_index "architects_buildings", ["architect_id", "building_id"], name: "architects_buildings_index", unique: true, using: :btree

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",          default: 0
    t.datetime "created_at"
    t.string   "comment"
    t.string   "remote_address"
    t.integer  "association_id"
    t.string   "association_type"
  end

  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "building_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buildings", force: :cascade do |t|
    t.string   "name",                                                               null: false
    t.string   "city",                                            default: "Ithaca", null: false
    t.string   "state",                                           default: "NY",     null: false
    t.string   "postal_code",                                     default: "14850",  null: false
    t.integer  "year_earliest"
    t.integer  "year_latest"
    t.integer  "building_type_id"
    t.text     "description"
    t.decimal  "lat",                   precision: 15, scale: 10
    t.decimal  "lon",                   precision: 15, scale: 10
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.boolean  "year_earliest_circa",                             default: false
    t.boolean  "year_latest_circa",                               default: false
    t.string   "address_house_number"
    t.string   "address_street_prefix"
    t.string   "address_street_name"
    t.string   "address_street_suffix"
    t.float    "stories"
    t.text     "annotations"
    t.integer  "lining_type_id"
    t.integer  "frame_type_id"
    t.string   "block_number"
    t.integer  "created_by_id"
    t.integer  "reviewed_by_id"
    t.datetime "reviewed_at"
  end

  add_index "buildings", ["building_type_id"], name: "index_buildings_on_building_type_id", using: :btree
  add_index "buildings", ["created_by_id"], name: "index_buildings_on_created_by_id", using: :btree
  add_index "buildings", ["frame_type_id"], name: "index_buildings_on_frame_type_id", using: :btree
  add_index "buildings", ["lining_type_id"], name: "index_buildings_on_lining_type_id", using: :btree
  add_index "buildings", ["reviewed_by_id"], name: "index_buildings_on_reviewed_by_id", using: :btree

  create_table "census_1900_records", force: :cascade do |t|
    t.jsonb    "data"
    t.integer  "building_id"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "census_1900_records", ["building_id"], name: "index_census_1900_records_on_building_id", using: :btree
  add_index "census_1900_records", ["person_id"], name: "index_census_1900_records_on_person_id", using: :btree

  create_table "census_1910_records", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "building_id"
    t.integer  "created_by_id"
    t.integer  "reviewed_by_id"
    t.datetime "reviewed_at"
    t.integer  "person_id"
  end

  add_index "census_1910_records", ["building_id"], name: "index_census_1910_records_on_building_id", using: :btree
  add_index "census_1910_records", ["created_by_id"], name: "index_census_1910_records_on_created_by_id", using: :btree
  add_index "census_1910_records", ["reviewed_by_id"], name: "index_census_1910_records_on_reviewed_by_id", using: :btree

  create_table "census_1920_records", force: :cascade do |t|
    t.jsonb    "data"
    t.integer  "building_id"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "census_1920_records", ["building_id"], name: "index_census_1920_records_on_building_id", using: :btree
  add_index "census_1920_records", ["person_id"], name: "index_census_1920_records_on_person_id", using: :btree

  create_table "client_applications", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          limit: 20
    t.string   "secret",       limit: 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], name: "index_client_applications_on_key", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment",                     default: ""
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "construction_materials", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gcps", force: :cascade do |t|
    t.integer  "map_id"
    t.float    "x"
    t.float    "y"
    t.decimal  "lat",        precision: 15, scale: 10
    t.decimal  "lon",        precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "soft",                                 default: false
    t.string   "name"
  end

  add_index "gcps", ["soft"], name: "index_gcps_on_soft", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_maps", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups_maps", ["map_id", "group_id"], name: "index_groups_maps_on_map_id_and_group_id", unique: true, using: :btree
  add_index "groups_maps", ["map_id"], name: "index_groups_maps_on_map_id", using: :btree

  create_table "imports", force: :cascade do |t|
    t.string   "path"
    t.string   "name"
    t.string   "layer_title"
    t.string   "map_title_suffix"
    t.string   "map_description"
    t.string   "map_publisher"
    t.string   "map_author"
    t.string   "state"
    t.integer  "layer_id"
    t.integer  "uploader_user_id"
    t.integer  "user_id"
    t.integer  "file_count"
    t.integer  "imported_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "bbox"
    t.integer  "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "depicts_year",         limit: 4,                               default: ""
    t.integer  "maps_count",                                                   default: 0
    t.integer  "rectified_maps_count",                                         default: 0
    t.boolean  "is_visible",                                                   default: true
    t.string   "source_uri"
    t.geometry "bbox_geom",            limit: {:srid=>4326, :type=>"polygon"}
  end

  add_index "layers", ["bbox_geom"], name: "index_layers_on_bbox_geom", using: :gist

  create_table "layers_maps", force: :cascade do |t|
    t.integer  "layer_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layers_maps", ["layer_id"], name: "index_layers_maps_on_layer_id", using: :btree
  add_index "layers_maps", ["map_id"], name: "index_layers_maps_on_map_id", using: :btree

  create_table "maps", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "filename"
    t.integer  "width"
    t.integer  "height"
    t.integer  "status"
    t.integer  "mask_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_file_updated_at"
    t.string   "bbox"
    t.string   "publisher"
    t.string   "authors"
    t.string   "scale"
    t.datetime "published_date"
    t.datetime "reprint_date"
    t.integer  "owner_id"
    t.boolean  "public",                                                                                   default: true
    t.boolean  "downloadable",                                                                             default: true
    t.string   "cached_tag_list"
    t.integer  "map_type",                                                                                 default: 1
    t.string   "source_uri"
    t.geometry "bbox_geom",              limit: {:srid=>4236, :type=>"polygon"}
    t.decimal  "rough_lat",                                                      precision: 15, scale: 10
    t.decimal  "rough_lon",                                                      precision: 15, scale: 10
    t.geometry "rough_centroid",         limit: {:srid=>4326, :type=>"point"}
    t.integer  "rough_zoom"
    t.integer  "rough_state"
    t.integer  "import_id"
    t.string   "publication_place"
    t.string   "subject_area"
    t.string   "unique_id"
    t.string   "metadata_projection"
    t.decimal  "metadata_lat",                                                   precision: 15, scale: 10
    t.decimal  "metadata_lon",                                                   precision: 15, scale: 10
    t.string   "date_depicted",          limit: 4,                                                         default: ""
    t.string   "call_number"
    t.datetime "rectified_at"
    t.datetime "gcp_touched_at"
  end

  add_index "maps", ["bbox_geom"], name: "index_maps_on_bbox_geom", using: :gist
  add_index "maps", ["rough_centroid"], name: "index_maps_on_rough_centroid", using: :gist

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true, using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "my_maps", force: :cascade do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_maps", ["map_id", "user_id"], name: "index_my_maps_on_map_id_and_user_id", unique: true, using: :btree
  add_index "my_maps", ["map_id"], name: "index_my_maps_on_map_id", using: :btree

  create_table "oauth_nonces", force: :cascade do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true, using: :btree

  create_table "oauth_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type",                  limit: 20
    t.integer  "client_application_id"
    t.string   "token",                 limit: 20
    t.string   "secret",                limit: 40
    t.string   "callback_url"
    t.string   "verifier",              limit: 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], name: "index_oauth_tokens_on_token", unique: true, using: :btree

  create_table "people", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "role_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "building_id"
    t.integer  "position"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_size"
    t.integer  "width"
    t.integer  "height"
    t.text     "caption"
    t.integer  "year_taken"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "photos", ["building_id"], name: "index_photos_on_building_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.string   "context",       limit: 128
    t.integer  "tagger_id"
    t.string   "tagger_type"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "email"
    t.string   "encrypted_password",        limit: 128, default: "",   null: false
    t.string   "password_salt",                         default: "",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.string   "reset_password_token"
    t.boolean  "enabled",                               default: true
    t.integer  "updated_by"
    t.text     "description",                           default: ""
    t.datetime "confirmation_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "reset_password_sent_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_foreign_key "buildings", "building_types"
  add_foreign_key "buildings", "users", column: "created_by_id"
  add_foreign_key "buildings", "users", column: "reviewed_by_id"
  add_foreign_key "census_1900_records", "buildings"
  add_foreign_key "census_1900_records", "people"
  add_foreign_key "census_1910_records", "buildings"
  add_foreign_key "census_1910_records", "people"
  add_foreign_key "census_1910_records", "users", column: "created_by_id"
  add_foreign_key "census_1910_records", "users", column: "reviewed_by_id"
  add_foreign_key "census_1920_records", "buildings"
  add_foreign_key "census_1920_records", "people"
  add_foreign_key "photos", "buildings"
end
