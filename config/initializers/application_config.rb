# To prevent legacy errors looking to obsolete APP_CONFIG constant
APP_CONFIG = {}

AppConfig = OpenStruct.new

AppConfig.city = ENV['APP_PLACE_CITY'] || "Ithaca"
AppConfig.state = ENV['APP_PLACE_STATE'] || "NY"
AppConfig.organization = ENV['APP_ORG_NAME'] || "The History Center in Tompkins County"
AppConfig.url = ENV['APP_ORG_URL'] || "https://thehistorycenter.net"
AppConfig.latitude = ENV['APP_LATITUDE'] || 42.4418353
AppConfig.longitude = ENV['APP_LONGITUDE'] || -76.4987984

