class CreateOccupation1930Codes < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation1930_codes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
