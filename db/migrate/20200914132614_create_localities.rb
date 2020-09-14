class CreateLocalities < ActiveRecord::Migration[6.0]
  def change
    create_table :localities do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.integer :position

      t.timestamps
    end

    [1900, 1910, 1920, 1930, 1940].each do |year|
      change_table "census_#{year}_records" do |t|
        t.references :locality, foreign_key: true
      end
    end

    change_table :map_overlays do |t|
      t.references :locality, foreign_key: true
    end

    reversible do |dir|
      dir.up do
        ithaca = Locality.create name: 'City of Ithaca', latitude: 42.4418353, longitude: -76.4987984, position: 1
        [1900, 1910, 1920, 1930, 1940].each do |year|
          "Census#{year}Record".constantize.update_all locality_id: ithaca.id
        end
        MapOverlay.update_all locality_id: ithaca.id
        Locality.create name: 'Town of Ithaca', latitude: 42.4418353, longitude: -76.4987984, position: 2
        Locality.create name: 'Cayuga Heights', latitude: 42.4671327, longitude: -76.5250159, position: 3
      end
    end
  end
end
