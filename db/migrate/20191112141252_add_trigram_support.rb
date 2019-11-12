class AddTrigramSupport < ActiveRecord::Migration[5.2]
  def up
    enable_extension :pg_trgm
    create_trigram_index :census_1900_records
    create_trigram_index :census_1910_records
    create_trigram_index :census_1920_records
    create_trigram_index :census_1930_records

    add_column :people, :name_prefix, :string
    add_column :people, :name_suffix, :string
    create_trigram_index :people
  end

  def down
    disable_extension :pg_trgm
    drop_trigram_index :census_1900_records
    drop_trigram_index :census_1910_records
    drop_trigram_index :census_1920_records
    drop_trigram_index :census_1930_records
    drop_trigram_index :people
    remove_column :people, :name_prefix
    remove_column :people, :name_suffix
  end

  def create_trigram_index(table)
    change_table table do |t|
      t.text :searchable_name
    end
    execute "update #{table} set searchable_name=concat_ws(' ', name_prefix, first_name, middle_name, last_name, name_suffix)"
    execute "create index #{table}_name_trgm on #{table} using gist(searchable_name gist_trgm_ops)"
  end

  def drop_trigram_index(table)
    remove_column table, :searchable_name
    # remove_index table, "#{table}_name_trgm"
  end
end
