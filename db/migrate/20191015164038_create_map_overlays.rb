class CreateMapOverlays < ActiveRecord::Migration[5.2]
  def change
    create_table :map_overlays do |t|
      t.string :name
      t.integer :year_depicted
      t.string :url
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end
end
