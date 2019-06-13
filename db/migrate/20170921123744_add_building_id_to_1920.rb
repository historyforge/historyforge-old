class AddBuildingIdTo1920 < ActiveRecord::Migration[4.2]
  def change
    change_table :census_1920_records do |t|
      t.references :person, foreign_key: true, after: :id
      t.references :building, foreign_key: true, after: :person_id
      t.timestamps
    end
  end
end
