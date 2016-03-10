class LinkCensusRecordToBuilding < ActiveRecord::Migration
  def change
    change_table :census_records do |t|
      t.references :building, index: true, foreign_key: true, after: 'id'
    end
  end
end
