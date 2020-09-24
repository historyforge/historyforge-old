class Load1910People < ActiveRecord::Migration[6.0]
  def up
    Census1910Record.update_all person_id: nil
    Person.delete_all
    execute "ALTER SEQUENCE people_id_seq RESTART WITH 1"
    Census1910Record.find_each do |row|
      person = Person.new
      %w{last_name first_name middle_name sex race name_prefix name_suffix}.each do |attribute|
        person[attribute] = row[attribute]
      end
      person.save!
      row.update_column :person_id, person.id
    end
  end

  def down
  end
end
