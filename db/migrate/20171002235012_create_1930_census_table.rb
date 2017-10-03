class Create1930CensusTable < ActiveRecord::Migration
  def change
    create_table :census_1930_records, force: :cascade do |t|
      t.references :building, foreign_key: true, index: true
      t.references :person, foreign_key: true, index: true
      t.references :created_by, index: true
      t.references :reviewed_by, index: true
      t.datetime :reviewed_at
      t.integer  :page_number
      t.string   :page_side,            limit: 1
      t.integer  :line_number
      t.string   :county,                          default: 'Tompkins'
      t.string   :city,                            default: 'Ithaca'
      t.string   :state,                           default: 'NY'
      t.string   :ward
      t.string   :enum_dist
      t.string   :street_prefix
      t.string   :street_name
      t.string   :street_suffix
      t.string   :street_house_number
      t.string   :dwelling_number
      t.string   :family_id
      t.string   :last_name
      t.string   :first_name
      t.string   :middle_name
      t.string   :relation_to_head
      t.string   :owned_or_rented,      limit: 10
      t.integer  :home_value
      t.boolean  :has_radio
      t.boolean  :lives_on_farm
      t.string   :sex,                  limit: 1
      t.string   :race,                 limit: 1
      t.integer  :age
      t.string   :marital_status,       limit: 2
      t.integer :age_married
      t.boolean :educated_since_1929
      t.boolean :can_read_write
      t.string   :pob,                             default: 'New York'
      t.string   :pob_father,                      default: 'New York'
      t.string   :pob_mother,                      default: 'New York'
      t.string   :pob_code
      t.string   :pob_code_father
      t.string   :pob_code_mother
      t.string   :mother_tongue
      t.integer  :year_immigrated
      t.string   :naturalized_alien
      t.boolean  :can_speak_english
      t.string   :occupation
      t.string   :industry
      t.string   :occupation_code
      t.string   :worker_class
      t.boolean  :worked_yesterday
      t.string   :unemployment_line
      t.boolean  :veteran
      t.string   :war_fought
      t.string   :farm_schedule
      t.text     :notes
      t.boolean  :provisional,                     default: false
      t.boolean  :foreign_born,                    default: false
      t.boolean  :taker_error,                     default: false
      t.timestamps null: true
    end

    add_foreign_key :census_1900_records, :users, column: :created_by_id
    add_foreign_key :census_1900_records, :users, column: :reviewed_by_id
    add_foreign_key :census_1920_records, :users, column: :created_by_id
    add_foreign_key :census_1920_records, :users, column: :reviewed_by_id
    add_foreign_key :census_1930_records, :users, column: :created_by_id
    add_foreign_key :census_1930_records, :users, column: :reviewed_by_id

    add_index :census_1920_records, :building_id
    add_index :census_1920_records, :person_id
  end
end
