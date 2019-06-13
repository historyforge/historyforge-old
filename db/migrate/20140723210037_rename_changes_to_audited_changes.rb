class RenameChangesToAuditedChanges < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :audits, :changes, :audited_changes
  end

  def self.down
    rename_column :audits, :audited_changes, :changes
  end
end
