class AddMissingIndexAndPersonFields < ActiveRecord::Migration[6.0]
  def change
    add_index :census_1910_records, :person_id, unique: true
    change_table :people do |t|
      t.integer :birth_year
      t.boolean :is_birth_year_estimated, default: true
      t.string :pob
      t.boolean :is_pob_estimated, default: true
    end
    reversible do |dir|
      dir.up do
        Person.find_each do |person|
          person.save
        end
      end
    end
  end
end
