class CreateStreetConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :street_conversions do |t|
      t.string :from_prefix
      t.string :to_prefix
      t.string :from_name
      t.string :to_name
      t.string :from_suffix
      t.string :to_suffix
      t.string :from_city
      t.string :to_city

      t.timestamps
    end
  end
end
