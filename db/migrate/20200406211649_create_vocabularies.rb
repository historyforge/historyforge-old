class CreateVocabularies < ActiveRecord::Migration[6.0]
  def change
    create_table :vocabularies do |t|
      t.string :name
      t.string :machine_name, index: true

      t.timestamps
    end
  end
end
