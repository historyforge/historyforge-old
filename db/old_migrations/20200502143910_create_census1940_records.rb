class CreateCensus1940Records < ActiveRecord::Migration[6.0]
  def change
    create_table :census_1940_records do |t|
      t.references :building, foreign_key: true
      t.references :person, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :reviewed_by, foreign_key: { to_table: :users }
      t.datetime "reviewed_at"
      t.integer "page_number"
      t.string "page_side", limit: 1
      t.integer "line_number"
      t.string "county", default: "Tompkins"
      t.string "city", default: "Ithaca"
      t.string "state", default: "NY"
      t.string "ward"
      t.string "enum_dist"
      t.string "apartment_number"
      t.string "street_prefix"
      t.string "street_name"
      t.string "street_suffix"
      t.string "street_house_number"
      t.string "dwelling_number"
      t.string "family_id"
      t.string "last_name"
      t.string "first_name"
      t.string "middle_name"
      t.string "name_prefix"
      t.string "name_suffix"
      t.text "searchable_name"

      t.string "owned_or_rented"
      t.integer "home_value"
      t.boolean "lives_on_farm"

      t.string "relation_to_head"
      t.string :relation_code

      t.string "sex"
      t.string "race"
      t.integer "age"
      t.integer "age_months"
      t.string "marital_status"
      t.boolean "attended_school"
      t.string :grade_completed
      t.string :education_code

      t.string "pob", default: "New York"
      t.string "pob_code"
      t.string :naturalized_alien

      t.string :residence_1935_town
      t.string :residence_1935_county
      t.string :residence_1935_state
      t.boolean :residence_1935_farm
      t.string :residence_1935_code

      t.boolean :private_work
      t.boolean :public_work
      t.boolean :seeking_work
      t.boolean :had_job
      t.string :no_work_reason
      t.string :no_work_code
      t.integer :private_hours_worked
      t.integer :unemployed_weeks

      t.string "profession", default: "None"
      t.string "industry"
      t.string "worker_class"
      t.string "profession_code"
      t.integer :full_time_weeks
      t.integer :income
      t.boolean :had_unearned_income
      t.string "farm_schedule"

      # SUPPLEMENTAL QUESTIONS
      t.string "pob_father", default: "New York"
      t.string "pob_mother", default: "New York"
      t.string "pob_father_code"
      t.string "pob_mother_code"
      t.string "mother_tongue"
      t.string :mother_tongue_code
      t.boolean "veteran"
      t.boolean :veteran_dead
      t.string "war_fought"
      t.string :war_fought_code
      t.boolean :soc_sec
      t.boolean :deductions
      t.string :deduction_rate
      t.string :usual_profession
      t.string :usual_industry
      t.string :usual_worker_class
      t.string :usual_occupation_code
      t.string :usual_industry_code
      t.string :usual_worker_class_code
      t.boolean :multi_marriage
      t.integer :first_marriage_age
      t.integer :children_born


      t.text "notes"
      t.boolean "provisional", default: false
      t.boolean "foreign_born", default: false
      t.boolean "taker_error", default: false

      t.timestamps
    end
  end
end
