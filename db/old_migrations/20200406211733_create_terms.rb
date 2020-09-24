class CreateTerms < ActiveRecord::Migration[6.0]
  def change
    create_table :terms do |t|
      t.references :vocabulary, foreign_key: true
      t.string :name, index: true

      t.timestamps
    end
  end
end
