class RemoveOldMigrations < ActiveRecord::Migration[6.0]
  def up
    migration_files = Dir.entries(Rails.root.join('db', 'migrate'))
    ActiveRecord::Base.connection.execute("SELECT version FROM schema_migrations").each do |migration|
      version = migration['version']
      exists = migration_files.detect { |file| file.starts_with?(version) }.inspect
      unless exists
        execute "DELETE FROM schema_migrations WHERE version=#{version}"
      end
    end
  end

  def down
  end
end
