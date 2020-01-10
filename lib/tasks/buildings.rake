namespace :buildings do
  task dedupe_photos: :environment do
    Building.joins(:photos).each do |building|
      if building.photos.size == 2 && building.photos.first.id == building.photos.second.id
        photo = building.photos.first
        building.photos = [photo]
        building.save
      end
    end
  end

  task import: :environment do

    file = ENV['file']
    raise 'You must specify a filename like so: rake buildings:import file=path/to/file' if file.blank?

    require 'rubyXL'
    RubyXL::Parser.parse(file).worksheets.each do |sheet|
      sheet.each_with_index do |row, i|
        next unless row && row[0] && row[0].value
        if i == 0
          raise 'Does not look like a HistoryForge-Buildings template file' if row[0].value != 'BuildingName'
        else

          name    = row[0].value.strip
          address = row[1].value.strip
          city    = row[2].value.strip
          state   = row[3].value.strip

          building = Building.where(name: name, address: address, city: city, state: state).first_or_initialize
          building.postal_code   = row[4].andand.value
          building.lat           = row[5].andand.value
          building.lon           = row[6].andand.value
          building.year_earliest = row[7].andand.value
          building.year_latest   = row[8].andand.value
          building.building_type = row[9] && BuildingType.where(name: row[9].value.strip).first_or_create
          if row[10].andand.value
            building.architects    = row[10].value.split("\n").map(&:strip).map {|name| Architect.where(name: name).first_or_create }
          end
          building.description   = row[11].value.strip if row[11].andand.value
          building.save!

        end

      end
    end


  end
end
