class FleshOutPeople < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :data, :jsonb
    change_table :people do |t|
      t.string   "last_name"
      t.string   "first_name"
      t.string   "middle_name"
      t.string   "sex",                  limit: 1
      t.string   "race",                 limit: 1
    end
  end
end
