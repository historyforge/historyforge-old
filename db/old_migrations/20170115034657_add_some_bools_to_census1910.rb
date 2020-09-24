class AddSomeBoolsToCensus1910 < ActiveRecord::Migration[4.2]
  def change
    add_column :census_1910_records, :provisional, :boolean, default: false
    add_column :census_1910_records, :foreign_born, :boolean, default: false
    Census1910Record.update_all provisional: false, foreign_born: false
    Census1910Record.where(profession: nil).update_all profession: 'None'
    Census1910Record.where(profession: '').update_all profession: 'None'
  end
end
