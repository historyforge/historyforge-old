# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

BuildingType.where(name: 'public').first_or_create
BuildingType.where(name: 'residence').first_or_create
BuildingType.where(name: 'religious').first_or_create
BuildingType.where(name: 'commercial').first_or_create

ConstructionMaterial.where(name: 'wood', color: 'yellow').first_or_create
ConstructionMaterial.where(name: 'brick', color: 'red').first_or_create
ConstructionMaterial.where(name: 'stone', color: 'blue').first_or_create
ConstructionMaterial.where(name: 'iron', color: 'gray').first_or_create
ConstructionMaterial.where(name: 'adobe', color: 'green').first_or_create

file = File.open(Rails.root.join('db', 'PhysicalFormats.txt')).read
entries = file.split("\n\n")
entries.each do |row|
  entry = row.split("\n")
  types = entry[1].split(";").map(&:strip).map { |t| PhysicalType.where(name: t.titleize).first_or_create }

  item = PhysicalFormat.find_or_initialize_by name: entry[0]
  item.description = entry[2]
  item.physical_types = types
  item.save
end

file = File.open(Rails.root.join('db', 'RightsStatements.txt')).read
entries = file.split("\n\n")
entries.each do |row|
  entry = row.split("\n")
  RightsStatement.find_or_create_by name: entry[0], description: entry[1], url: entry[2]
end

