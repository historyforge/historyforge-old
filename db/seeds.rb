# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

BuildingType.where(name: 'religious').first_or_create
BuildingType.where(name: 'commercial').first_or_create

ConstructionMaterial.where(name: 'wood', color: 'yellow').first_or_create
ConstructionMaterial.where(name: 'brick', color: 'red').first_or_create
ConstructionMaterial.where(name: 'stone', color: 'blue').first_or_create
ConstructionMaterial.where(name: 'iron', color: 'gray').first_or_create
ConstructionMaterial.where(name: 'adobe', color: 'green').first_or_create
