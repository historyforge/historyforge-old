class CreateRightsStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :rights_statements do |t|
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        file = File.open(File.join(File.dirname(__FILE__), '..', 'RightsStatements.txt')).read
        entries = file.split("\n\n")
        entries.each do |row|
          entry = row.split("\n")
          RightsStatement.create name: entry[0], description: entry[1], url: entry[2]
        end
      end
    end

  end
end
