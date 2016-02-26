class AddCircaToBuildings < ActiveRecord::Migration
  def change
    change_table :buildings do |t|
      t.boolean :year_earliest_circa, after: :year_earliest, default: false
      t.boolean :year_latest_circa, after: :year_latest, default: false
    end
  end
end
