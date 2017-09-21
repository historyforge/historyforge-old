class Change1900CensusRecords < ActiveRecord::Migration
  def change

    change_table "census_1900_records", force: :cascade do |t|
      t.integer  "created_by_id"
      t.integer  "reviewed_by_id"
      t.datetime "reviewed_at"
      t.integer  "page_number"
      t.string   "page_side",             limit: 1
      t.integer  "line_number"
      t.string   "county",                           default: "Tompkins"
      t.string   "city",                             default: "Ithaca"
      t.string   "state",                            default: "NY"
      t.string   "ward"
      t.string   "enum_dist"
      t.string   "street_prefix"
      t.string   "street_name"
      t.string   "street_suffix"
      t.string   "street_house_number"
      t.string   "dwelling_number"
      t.string   "family_id"
      t.string   "last_name"
      t.string   "first_name"
      t.string   "middle_name"
      t.string   "relation_to_head"

      t.string   "sex",                   limit: 1
      t.string   "race",                  limit: 1

      t.integer :birth_month
      t.integer :birth_year
      t.integer  "age"

      t.string   "marital_status",        limit: 2
      t.integer  "years_married"
      t.integer  "num_children_born"
      t.integer  "num_children_alive"
      t.string   "pob",                              default: "New York"
      t.string   "pob_father",                       default: "New York"
      t.string   "pob_mother",                       default: "New York"

      t.integer  "year_immigrated"
      t.string   "naturalized_alien"
      t.integer :years_in_us

      t.string   "profession"
      t.integer :unemployed_months

      # t.string   "industry"
      # t.string   "employment"
      # t.boolean  "unemployed"
      t.boolean  "attended_school"
      t.boolean  "can_read"
      t.boolean  "can_write"
      t.boolean  "can_speak_english"

      t.string   "owned_or_rented",       limit: 10
      t.string   "mortgage",              limit: 1
      t.string   "farm_or_house",         limit: 1

      # t.string   "num_farm_sched"
      t.string   "language_spoken",                  default: "English"
      # t.string   "unemployed_weeks_1909"
      # t.boolean  "civil_war_vet_old"
      # t.boolean  "blind",                            default: false
      # t.boolean  "deaf_dumb",                        default: false
      t.text     "notes"
      # t.string   "civil_war_vet",         limit: 2
      t.boolean  "provisional",                      default: false
      t.boolean  "foreign_born",                     default: false
      t.boolean  "taker_error",                      default: false
    end

    create_table "census_1920_records", force: :cascade do |t|
      t.integer  "created_by_id"
      t.integer  "reviewed_by_id"
      t.datetime "reviewed_at"
      t.integer  "page_number"
      t.string   "page_side",             limit: 1
      t.integer  "line_number"
      t.string   "county",                           default: "Tompkins"
      t.string   "city",                             default: "Ithaca"
      t.string   "state",                            default: "NY"
      t.string   "ward"
      t.string   "enum_dist"
      t.string   "street_prefix"
      t.string   "street_name"
      t.string   "street_suffix"
      t.string   "street_house_number"
      t.string   "dwelling_number"
      t.string   "family_id"
      t.string   "last_name"
      t.string   "first_name"
      t.string   "middle_name"
      t.string   "relation_to_head"
      t.string   "sex",                   limit: 1
      t.string   "race",                  limit: 1
      t.integer  "age"
      t.string   "marital_status",        limit: 2

      t.integer  "year_immigrated"
      t.string   "naturalized_alien"

      t.string   "pob",                              default: "New York"
      t.string :mother_tongue
      t.string   "pob_father",                       default: "New York"
      t.string :mother_tongue_father
      t.string   "pob_mother",                       default: "New York"
      t.string :mother_tongue_mother
      t.boolean  "can_speak_english"

      # t.integer  "years_married"
      # t.integer  "num_children_born"
      # t.integer  "num_children_alive"
      t.string   "profession"
      t.string   "industry"
      t.string   "employment"

      # t.boolean  "unemployed"
      # t.boolean  "attended_school"
      # t.boolean  "can_read"
      # t.boolean  "can_write"
      t.string   "owned_or_rented",       limit: 10
      t.string   "mortgage",              limit: 1
      t.string   "farm_or_house",         limit: 1
      # t.string   "num_farm_sched"
      # t.string   "language_spoken",                  default: "English"
      # t.string   "unemployed_weeks_1909"
      # t.boolean  "civil_war_vet_old"
      # t.boolean  "blind",                            default: false
      # t.boolean  "deaf_dumb",                        default: false
      t.text     "notes"
      # t.string   "civil_war_vet",         limit: 2
      t.boolean  "provisional",                      default: false
      t.boolean  "foreign_born",                     default: false
      t.boolean  "taker_error",                      default: false
    end

  end
end
