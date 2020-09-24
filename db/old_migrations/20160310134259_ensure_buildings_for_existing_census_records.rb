class EnsureBuildingsForExistingCensusRecords < ActiveRecord::Migration[4.2]
  def change
    CensusRecord.find_each do |record|
      record.save
    end
  end
end
