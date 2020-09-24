class AddMotherTongueTo1910 < ActiveRecord::Migration[6.0]
  def change
    change_table :census_1910_records do |t|
      t.string "mother_tongue", after: 'pob'
      t.string "mother_tongue_father", after: 'pob_father'
      t.string "mother_tongue_mother", after: 'pob_mother'
    end
  end
end
