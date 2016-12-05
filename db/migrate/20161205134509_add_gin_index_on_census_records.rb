class AddGinIndexOnCensusRecords < ActiveRecord::Migration
  def change
    add_index :census_1900_records, :data, using: :gin
    add_index :census_1910_records, :data, using: :gin
    add_index :census_1920_records, :data, using: :gin
  end
end
