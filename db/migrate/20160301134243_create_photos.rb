class CreatePhotos < ActiveRecord::Migration[4.2]
  def change
    create_table :photos do |t|
      t.references :building, index: true, foreign_key: true
      t.integer :position
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_size
      t.integer :width
      t.integer :height
      t.text :caption
      t.integer :year_taken

      t.timestamps null: false
    end
  end
end
