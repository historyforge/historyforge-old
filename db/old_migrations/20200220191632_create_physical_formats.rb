class CreatePhysicalFormats < ActiveRecord::Migration[6.0]
  def change
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

    reversible do |dir|
      dir.up do
        file = File.open(File.join(File.dirname(__FILE__), '..', 'PhysicalFormats.txt')).read
        entries = file.split("\n\n")
        entries.each do |row|
          entry = row.split("\n")
          types = entry[1].split(";").map(&:strip).map { |t| PhysicalType.where(name: t).first_or_create }

          item = PhysicalFormat.new name: entry[0], description: entry[2]
          item.physical_types = types
          item.save
        end
      end
    end
  end
end
