class Convert1910CensusRecordsFromJson < ActiveRecord::Migration
  def change
    change_table :census_1910_records do |t|

      t.integer :page_number
      t.string :page_side, limit: 1
      t.integer :line_number
      t.string :county, default: 'Tompkins'
      t.string :city, default: 'Ithaca'
      t.string :state, default: 'NY'
      t.string :ward
      t.string :enum_dist
      t.string :street_prefix
      t.string :street_name
      t.string :street_suffix
      t.string :street_house_number
      t.string :dwelling_number
      t.string :family_id
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :relation_to_head
      t.string :sex, limit: 1
      t.string :race, limit: 1
      t.integer :age
      t.string :marital_status, limit: 2
      t.integer :years_married
      t.integer :num_children_born
      t.integer :num_children_alive
      t.string :pob, default: 'New York'
      t.string :pob_father, default: 'New York'
      t.string :pob_mother, default: 'New York'
      t.integer :year_immigrated
      t.string :naturalized_alien
      t.string :profession
      t.string :industry
      t.string :employment
      t.boolean :unemployed
      t.boolean :attended_school
      t.boolean :can_read
      t.boolean :can_write
      t.boolean :can_speak_english
      t.string :owned_or_rented, limit: 1
      t.string :mortgage, limit: 1
      t.string :farm_or_house, limit: 1
      t.string :num_farm_sched, as: :integer
      t.string :language_spoken, default: 'English'
      t.string :unemployed_weeks_1909
      t.boolean :civil_war_vet
      t.boolean :blind
      t.boolean :deaf_dumb
      t.text :notes

    end

    if column_exists?(:census_1910_records, :deaf_dumb)
      Census1910Record.find_each do |row|
        row.data.keys.each do |key|
          next if key == 'page_number'
          if key == 'page_no'
            row.page_number = row.data['page_no']
          else
            row.public_send("#{key}=", row.data[key])
          end
        end
        row.save
      end
    end
  end
end
