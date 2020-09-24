class CreateProfessionSubgroups < ActiveRecord::Migration[6.0]
  def change
    create_table :profession_subgroups do |t|
      t.string :name
      t.references :profession_group, foreign_key: true

      t.timestamps
    end
  end
end
