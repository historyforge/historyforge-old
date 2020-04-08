# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_08_134033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "architects", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "architects_buildings", id: false, force: :cascade do |t|
    t.integer "architect_id", null: false
    t.integer "building_id", null: false
    t.index ["architect_id", "building_id"], name: "architects_buildings_index", unique: true
  end

  create_table "building_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buildings", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "city", default: "Ithaca", null: false
    t.string "state", default: "NY", null: false
    t.string "postal_code", default: "14850", null: false
    t.integer "year_earliest"
    t.integer "year_latest"
    t.integer "building_type_id"
    t.text "description"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "year_earliest_circa", default: false
    t.boolean "year_latest_circa", default: false
    t.string "address_house_number"
    t.string "address_street_prefix"
    t.string "address_street_name"
    t.string "address_street_suffix"
    t.float "stories"
    t.text "annotations"
    t.integer "lining_type_id"
    t.integer "frame_type_id"
    t.string "block_number"
    t.integer "created_by_id"
    t.integer "reviewed_by_id"
    t.datetime "reviewed_at"
    t.boolean "investigate", default: false
    t.string "investigate_reason"
    t.text "notes"
    t.index ["building_type_id"], name: "index_buildings_on_building_type_id"
    t.index ["created_by_id"], name: "index_buildings_on_created_by_id"
    t.index ["frame_type_id"], name: "index_buildings_on_frame_type_id"
    t.index ["lining_type_id"], name: "index_buildings_on_lining_type_id"
    t.index ["reviewed_by_id"], name: "index_buildings_on_reviewed_by_id"
  end

  create_table "buildings_photographs", id: false, force: :cascade do |t|
    t.bigint "photograph_id", null: false
    t.bigint "building_id", null: false
  end

  create_table "buildings_photos", id: false, force: :cascade do |t|
    t.integer "building_id"
    t.integer "photo_id"
  end

  create_table "census_1900_records", id: :serial, force: :cascade do |t|
    t.jsonb "data"
    t.integer "building_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id"
    t.integer "reviewed_by_id"
    t.datetime "reviewed_at"
    t.integer "page_number"
    t.string "page_side", limit: 1
    t.integer "line_number"
    t.string "county", default: "Tompkins"
    t.string "city", default: "Ithaca"
    t.string "state", default: "NY"
    t.string "ward"
    t.string "enum_dist"
    t.string "street_prefix"
    t.string "street_name"
    t.string "street_suffix"
    t.string "street_house_number"
    t.string "dwelling_number"
    t.string "family_id"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "relation_to_head"
    t.string "sex"
    t.string "race"
    t.integer "birth_month"
    t.integer "birth_year"
    t.integer "age"
    t.string "marital_status"
    t.integer "years_married"
    t.integer "num_children_born"
    t.integer "num_children_alive"
    t.string "pob", default: "New York"
    t.string "pob_father", default: "New York"
    t.string "pob_mother", default: "New York"
    t.integer "year_immigrated"
    t.string "naturalized_alien"
    t.integer "years_in_us"
    t.string "profession", default: "None"
    t.integer "unemployed_months"
    t.boolean "attended_school_old"
    t.boolean "can_read"
    t.boolean "can_write"
    t.boolean "can_speak_english"
    t.string "owned_or_rented"
    t.string "mortgage"
    t.string "farm_or_house"
    t.string "language_spoken", default: "English"
    t.text "notes"
    t.boolean "provisional", default: false
    t.boolean "foreign_born", default: false
    t.boolean "taker_error", default: false
    t.integer "attended_school"
    t.string "industry"
    t.integer "farm_schedule"
    t.string "name_prefix"
    t.string "name_suffix"
    t.text "searchable_name"
    t.string "apartment_number"
    t.integer "age_months"
    t.index ["building_id"], name: "index_census_1900_records_on_building_id"
    t.index ["data"], name: "index_census_1900_records_on_data", using: :gin
    t.index ["person_id"], name: "index_census_1900_records_on_person_id"
    t.index ["searchable_name"], name: "census_1900_records_name_trgm", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "census_1910_records", id: :serial, force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "building_id"
    t.integer "created_by_id"
    t.integer "reviewed_by_id"
    t.datetime "reviewed_at"
    t.integer "person_id"
    t.integer "page_number"
    t.string "page_side", limit: 1
    t.integer "line_number"
    t.string "county", default: "Tompkins"
    t.string "city", default: "Ithaca"
    t.string "state", default: "NY"
    t.string "ward"
    t.string "enum_dist"
    t.string "street_prefix"
    t.string "street_name"
    t.string "street_suffix"
    t.string "street_house_number"
    t.string "dwelling_number"
    t.string "family_id"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "relation_to_head"
    t.string "sex"
    t.string "race"
    t.integer "age"
    t.string "marital_status"
    t.integer "years_married"
    t.integer "num_children_born"
    t.integer "num_children_alive"
    t.string "pob", default: "New York"
    t.string "pob_father", default: "New York"
    t.string "pob_mother", default: "New York"
    t.integer "year_immigrated"
    t.string "naturalized_alien"
    t.string "profession", default: "None"
    t.string "industry"
    t.string "employment"
    t.boolean "unemployed"
    t.boolean "attended_school"
    t.boolean "can_read"
    t.boolean "can_write"
    t.boolean "can_speak_english"
    t.string "owned_or_rented"
    t.string "mortgage"
    t.string "farm_or_house"
    t.string "num_farm_sched"
    t.string "language_spoken", default: "English"
    t.string "unemployed_weeks_1909"
    t.boolean "civil_war_vet_old"
    t.boolean "blind", default: false
    t.boolean "deaf_dumb", default: false
    t.text "notes"
    t.string "civil_war_vet", limit: 2
    t.boolean "provisional", default: false
    t.boolean "foreign_born", default: false
    t.boolean "taker_error", default: false
    t.string "name_prefix"
    t.string "name_suffix"
    t.text "searchable_name"
    t.string "apartment_number"
    t.integer "age_months"
    t.index ["building_id"], name: "index_census_1910_records_on_building_id"
    t.index ["created_by_id"], name: "index_census_1910_records_on_created_by_id"
    t.index ["data"], name: "index_census_1910_records_on_data", using: :gin
    t.index ["reviewed_by_id"], name: "index_census_1910_records_on_reviewed_by_id"
    t.index ["searchable_name"], name: "census_1910_records_name_trgm", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "census_1920_records", id: :serial, force: :cascade do |t|
    t.integer "created_by_id"
    t.integer "reviewed_by_id"
    t.datetime "reviewed_at"
    t.integer "page_number"
    t.string "page_side", limit: 1
    t.integer "line_number"
    t.string "county", default: "Tompkins"
    t.string "city", default: "Ithaca"
    t.string "state", default: "NY"
    t.string "ward"
    t.string "enum_dist"
    t.string "street_prefix"
    t.string "street_name"
    t.string "street_suffix"
    t.string "street_house_number"
    t.string "dwelling_number"
    t.string "family_id"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "relation_to_head"
    t.string "sex"
    t.string "race"
    t.integer "age"
    t.string "marital_status"
    t.integer "year_immigrated"
    t.string "naturalized_alien"
    t.string "pob", default: "New York"
    t.string "mother_tongue"
    t.string "pob_father", default: "New York"
    t.string "mother_tongue_father"
    t.string "pob_mother", default: "New York"
    t.string "mother_tongue_mother"
    t.boolean "can_speak_english"
    t.string "profession", default: "None"
    t.string "industry"
    t.string "employment"
    t.boolean "attended_school"
    t.boolean "can_read"
    t.boolean "can_write"
    t.string "owned_or_rented"
    t.string "mortgage"
    t.string "farm_or_house"
    t.text "notes"
    t.boolean "provisional", default: false
    t.boolean "foreign_born", default: false
    t.boolean "taker_error", default: false
    t.integer "person_id"
    t.integer "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name_prefix"
    t.string "name_suffix"
    t.integer "year_naturalized"
    t.integer "farm_schedule"
    t.text "searchable_name"
    t.string "apartment_number"
    t.integer "age_months"
    t.index ["building_id"], name: "index_census_1920_records_on_building_id"
    t.index ["person_id"], name: "index_census_1920_records_on_person_id"
    t.index ["searchable_name"], name: "census_1920_records_name_trgm", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "census_1930_records", id: :serial, force: :cascade do |t|
    t.integer "building_id"
    t.integer "person_id"
    t.integer "created_by_id"
    t.integer "reviewed_by_id"
    t.datetime "reviewed_at"
    t.integer "page_number"
    t.string "page_side", limit: 1
    t.integer "line_number"
    t.string "county", default: "Tompkins"
    t.string "city", default: "Ithaca"
    t.string "state", default: "NY"
    t.string "ward"
    t.string "enum_dist"
    t.string "street_prefix"
    t.string "street_name"
    t.string "street_suffix"
    t.string "street_house_number"
    t.string "dwelling_number"
    t.string "family_id"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "relation_to_head"
    t.string "owned_or_rented"
    t.integer "home_value"
    t.boolean "has_radio"
    t.boolean "lives_on_farm"
    t.string "sex"
    t.string "race"
    t.integer "age"
    t.string "marital_status"
    t.integer "age_married"
    t.boolean "attended_school"
    t.boolean "can_read_write"
    t.string "pob", default: "New York"
    t.string "pob_father", default: "New York"
    t.string "pob_mother", default: "New York"
    t.string "pob_code"
    t.string "pob_father_code"
    t.string "pob_mother_code"
    t.string "mother_tongue"
    t.integer "year_immigrated"
    t.string "naturalized_alien"
    t.boolean "can_speak_english"
    t.string "profession", default: "None"
    t.string "industry"
    t.string "profession_code"
    t.string "worker_class"
    t.boolean "worked_yesterday"
    t.string "unemployment_line"
    t.boolean "veteran"
    t.string "war_fought"
    t.string "farm_schedule"
    t.text "notes"
    t.boolean "provisional", default: false
    t.boolean "foreign_born", default: false
    t.boolean "taker_error", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name_prefix"
    t.string "name_suffix"
    t.text "searchable_name"
    t.integer "has_radio_int"
    t.integer "lives_on_farm_int"
    t.integer "attended_school_int"
    t.integer "can_read_write_int"
    t.integer "can_speak_english_int"
    t.integer "worked_yesterday_int"
    t.integer "veteran_int"
    t.integer "foreign_born_int"
    t.integer "homemaker_int"
    t.integer "age_months"
    t.string "apartment_number"
    t.boolean "homemaker"
    t.bigint "industry1930_code_id"
    t.bigint "occupation1930_code_id"
    t.index ["building_id"], name: "index_census_1930_records_on_building_id"
    t.index ["created_by_id"], name: "index_census_1930_records_on_created_by_id"
    t.index ["industry1930_code_id"], name: "index_census_1930_records_on_industry1930_code_id"
    t.index ["occupation1930_code_id"], name: "index_census_1930_records_on_occupation1930_code_id"
    t.index ["person_id"], name: "index_census_1930_records_on_person_id"
    t.index ["reviewed_by_id"], name: "index_census_1930_records_on_reviewed_by_id"
    t.index ["searchable_name"], name: "census_1930_records_name_trgm", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "client_applications", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "support_url"
    t.string "callback_url"
    t.string "key", limit: 20
    t.string "secret", limit: 40
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "index_client_applications_on_key", unique: true
  end

  create_table "construction_materials", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports", id: :serial, force: :cascade do |t|
    t.string "path"
    t.string "name"
    t.string "layer_title"
    t.string "map_title_suffix"
    t.string "map_description"
    t.string "map_publisher"
    t.string "map_author"
    t.string "state"
    t.integer "layer_id"
    t.integer "uploader_user_id"
    t.integer "user_id"
    t.integer "file_count"
    t.integer "imported_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industry1930_codes", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "map_overlays", force: :cascade do |t|
    t.string "name"
    t.integer "year_depicted"
    t.string "url"
    t.boolean "active"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_nonces", id: :serial, force: :cascade do |t|
    t.string "nonce"
    t.integer "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true
  end

  create_table "oauth_tokens", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "type", limit: 20
    t.integer "client_application_id"
    t.string "token", limit: 20
    t.string "secret", limit: 40
    t.string "callback_url"
    t.string "verifier", limit: 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["token"], name: "index_oauth_tokens_on_token", unique: true
  end

  create_table "occupation1930_codes", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "sex", limit: 1
    t.string "race", limit: 1
    t.string "name_prefix"
    t.string "name_suffix"
    t.text "searchable_name"
    t.index ["searchable_name"], name: "people_name_trgm", opclass: :gist_trgm_ops, using: :gist
  end

  create_table "people_photographs", id: false, force: :cascade do |t|
    t.bigint "photograph_id", null: false
    t.bigint "person_id", null: false
  end

  create_table "people_photos", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "photo_id"
  end

  create_table "permissions", id: :serial, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photographs", force: :cascade do |t|
    t.bigint "created_by_id"
    t.bigint "physical_type_id"
    t.bigint "physical_format_id"
    t.bigint "rights_statement_id"
    t.bigint "building_id"
    t.string "title"
    t.text "description"
    t.string "creator"
    t.string "subject"
    t.string "date_text"
    t.date "date_start"
    t.date "date_end"
    t.text "physical_description"
    t.string "location"
    t.string "identifier"
    t.text "notes"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["building_id"], name: "index_photographs_on_building_id"
    t.index ["created_by_id"], name: "index_photographs_on_created_by_id"
    t.index ["physical_format_id"], name: "index_photographs_on_physical_format_id"
    t.index ["physical_type_id"], name: "index_photographs_on_physical_type_id"
    t.index ["rights_statement_id"], name: "index_photographs_on_rights_statement_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "building_id"
    t.integer "position"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_size"
    t.integer "width"
    t.integer "height"
    t.text "caption"
    t.integer "year_taken"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_photos_on_building_id"
  end

  create_table "physical_formats", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "physical_formats_types", id: false, force: :cascade do |t|
    t.bigint "physical_format_id", null: false
    t.bigint "physical_type_id", null: false
  end

  create_table "physical_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rights_statements", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, default: nil, force: :cascade do |t|
    t.string "auth_name", limit: 256
    t.integer "auth_srid"
    t.string "srtext", limit: 2048
    t.string "proj4text", limit: 2048
  end

  create_table "street_conversions", force: :cascade do |t|
    t.string "from_prefix"
    t.string "to_prefix"
    t.string "from_name"
    t.string "to_name"
    t.string "from_suffix"
    t.string "to_suffix"
    t.string "from_city"
    t.string "to_city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.bigint "vocabulary_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_terms_on_name"
    t.index ["vocabulary_id"], name: "index_terms_on_vocabulary_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "email"
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "password_salt", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.string "reset_password_token"
    t.boolean "enabled", default: true
    t.integer "updated_by"
    t.text "description", default: ""
    t.datetime "confirmation_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "reset_password_sent_at"
    t.string "provider"
    t.string "uid"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "vocabularies", force: :cascade do |t|
    t.string "name"
    t.string "machine_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["machine_name"], name: "index_vocabularies_on_machine_name"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "buildings", "building_types"
  add_foreign_key "buildings", "users", column: "created_by_id"
  add_foreign_key "buildings", "users", column: "reviewed_by_id"
  add_foreign_key "buildings_photos", "buildings"
  add_foreign_key "buildings_photos", "photos"
  add_foreign_key "census_1900_records", "buildings"
  add_foreign_key "census_1900_records", "people"
  add_foreign_key "census_1900_records", "users", column: "created_by_id"
  add_foreign_key "census_1900_records", "users", column: "reviewed_by_id"
  add_foreign_key "census_1910_records", "buildings"
  add_foreign_key "census_1910_records", "people"
  add_foreign_key "census_1910_records", "users", column: "created_by_id"
  add_foreign_key "census_1910_records", "users", column: "reviewed_by_id"
  add_foreign_key "census_1920_records", "buildings"
  add_foreign_key "census_1920_records", "people"
  add_foreign_key "census_1920_records", "users", column: "created_by_id"
  add_foreign_key "census_1920_records", "users", column: "reviewed_by_id"
  add_foreign_key "census_1930_records", "buildings"
  add_foreign_key "census_1930_records", "industry1930_codes"
  add_foreign_key "census_1930_records", "occupation1930_codes"
  add_foreign_key "census_1930_records", "people"
  add_foreign_key "census_1930_records", "users", column: "created_by_id"
  add_foreign_key "census_1930_records", "users", column: "reviewed_by_id"
  add_foreign_key "people_photos", "people"
  add_foreign_key "people_photos", "photos"
  add_foreign_key "photographs", "buildings"
  add_foreign_key "photographs", "physical_formats"
  add_foreign_key "photographs", "physical_types"
  add_foreign_key "photographs", "rights_statements"
  add_foreign_key "photographs", "users", column: "created_by_id"
  add_foreign_key "photos", "buildings"
  add_foreign_key "terms", "vocabularies"
end
