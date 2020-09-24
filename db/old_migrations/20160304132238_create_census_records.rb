class CreateCensusRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :census_records do |t|
      t.string :type
      t.jsonb :data
      t.timestamps null: false
    end
  end
end
