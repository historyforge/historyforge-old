# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['super user', 'editor', 'reviewer', 'administrator', 'developer', 'builder', 'census taker'].each do |role|
  Role.find_or_create_by name: role
end

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

if Vocabulary.count == 0
  [
    ['Language Spoken', 'language'],
    ['Place of Birth', 'pob'],
    ['Relation to Head', 'relation_to_head']
  ].each do |item|
    file = File.open(Rails.root.join('db', "#{item[0]}.csv"))
    vocabulary = Vocabulary.find_or_create_by(name: item[0], machine_name: item[1])
    ImportTerms.new(file, vocabulary).run
  end
end

Setting.add 'county', value: ENV['APP_PLACE_COUNTY'] || "Tompkins", group: 'Census Record Defaults'
Setting.add 'city', value: ENV['APP_PLACE_CITY'] || "Ithaca", group: 'Census Record Defaults'
Setting.add 'state', value: ENV['APP_PLACE_STATE'] || "NY", group: 'Census Record Defaults'
Setting.add 'pob', value: 'New York', group: 'Census Record Defaults'
Setting.add 'postal_code', value: ENV['APP_PLACE_POSTAL_CODE'], group: 'Census Record Defaults'
Setting.add 'organization', value: ENV['APP_ORG_NAME'] || "The History Center in Tompkins County", group: 'Sponsor'
Setting.add 'url', value: ENV['APP_ORG_URL'] || "https://thehistorycenter.net", group: 'Sponsor'
Setting.add 'contact_email', value: ENV['CONTACT_EMAIL'] || "historyforge@thehistorycenter.net", group: 'Sponsor'
Setting.add 'mail_from', value: ENV['MAIL_FROM'] || "historyforge@thehistorycenter.net", group: 'Sponsor'
Setting.add 'latitude', value: ENV['APP_LATITUDE'] || 42.4418353, type: 'number', group: 'Default Map Center'
Setting.add 'longitude', value: ENV['APP_LONGITUDE'] || -76.4987984, type: 'number', group: 'Default Map Center'
Setting.add 'google_api_key', value: ENV['GOOGLE_API_KEY'], group: 'API Keys'
Setting.add 'geocoding_key', value: ENV['GOOGLE_GEOCODING_KEY'], group: 'API Keys'
Setting.add 'recaptcha_site_key', value: nil, group: 'API Keys'
Setting.add 'recaptcha_secret_key', value: nil, group: 'API Keys'

[1900, 1910, 1920, 1930, 1940].each do |year|
  group = "#{year} US Census"
  Setting.add "enabled_private_#{year}", type: :boolean, value: '1', group: group, name: 'Enabled Private', hint: 'This census year is available to logged-in users for data entry.'
  Setting.add "enabled_public_#{year}", type: :boolean, value: '1', group: group, name: 'Enabled Public', hint: 'This census year is available to the public for search.'
  Setting.add "add_buildings_#{year}", type: :boolean, value: '1', group: group, name: 'Add Buildings', hint: 'Allows census taker to create a new building from address.'
end

