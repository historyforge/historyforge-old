class CreatePhotographs < ActiveRecord::Migration[6.0]
  def change
    create_table :photographs do |t|
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :physical_type, foreign_key: true
      t.references :physical_format, foreign_key: true
      t.references :rights_statement, foreign_key: true
      t.string :title
      t.text :description
      t.string :creator
      t.string :subject
      t.string :date_text
      t.date :date_start
      t.date :date_end
      t.text :physical_description
      t.string :location
      t.string :identifier
      t.text :notes
      t.decimal :latitude
      t.decimal :longitude
      t.timestamps
    end
  end
end
