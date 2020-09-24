class CreateProfessions < ActiveRecord::Migration[6.0]
  def change
    create_table :professions do |t|
      t.string :code
      t.string :name
      t.references :profession_group, foreign_key: true
      t.references :profession_subgroup, foreign_key: true

      t.timestamps
    end
  end
end
