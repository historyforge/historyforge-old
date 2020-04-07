class CreateIndustry1930Codes < ActiveRecord::Migration[6.0]
  def change
    create_table :industry1930_codes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    change_table :census_1930_records do |t|
      t.references :industry1930_code, foreign_key: true
      t.references :occupation1930_code, foreign_key: true
    end
  end
end
