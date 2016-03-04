class CreateCensusRecords < ActiveRecord::Migration
  def change
    create_table :census_records do |t|
      t.string :type
      t.jsonb :data
      t.timestamps null: false
    end
  end
end
