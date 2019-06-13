class CreateMaps < ActiveRecord::Migration[4.2]
  def self.up
    create_table :maps do |t|
      t.string :title
      t.text :description
      t.string :filename
      t.integer :width
      t.integer :height
      t.integer :status
      t.integer :mask_status



      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
