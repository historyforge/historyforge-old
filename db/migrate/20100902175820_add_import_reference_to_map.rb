class AddImportReferenceToMap < ActiveRecord::Migration[4.2]
  def self.up
    add_column :maps, :import_id, :integer
  end

  def self.down
    remove_column :maps, :import_id
  end
end
