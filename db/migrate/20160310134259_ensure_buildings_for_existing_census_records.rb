class EnsureBuildingsForExistingCensusRecords < ActiveRecord::Migration
  def change
    CensusRecord.find_each do |record|
      record.save
    end
  end
end
