class RedoPhysicalFormats < ActiveRecord::Migration[6.0]
  def up
    remove_foreign_key :photographs, :physical_types
    remove_foreign_key :photographs, :physical_formats
    remove_column :photographs, :physical_format_id
    remove_column :photographs, :physical_type_id

    drop_table :physical_types
    drop_table :physical_formats
    drop_join_table :physical_formats, :physical_types

    create_table :physical_types do |t|
      t.string :name

      t.timestamps
    end
    create_table :physical_formats do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_join_table :physical_formats, :physical_types

    change_table :photographs do |t|
      t.references :physical_type, foreign_key: true
      t.references :physical_format, foreign_key: true
    end

    file = File.open(File.join(File.dirname(__FILE__), '..', 'PhysicalFormats.txt')).read
    entries = file.split("\n\n")
    entries.each do |row|
      entry = row.split("\n")
      types = entry[1].split(";").map(&:strip).map { |t| PhysicalType.where(name: t.titleize).first_or_create }

      item = PhysicalFormat.new name: entry[0], description: entry[2]
      item.physical_types = types
      item.save
    end
  end

  def down

  end
end
