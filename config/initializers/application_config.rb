# CONFIG_PATH="#{Rails.root}/config/application.yml"
#
# APP_CONFIG = YAML.load_file(CONFIG_PATH)[Rails.env]

#directories for maps and layer tileindex shapefiles
DST_MAPS_DIR = Rails.root.join('public', 'mapimages', 'dst').to_s
SRC_MAPS_DIR = Rails.root.join('public', 'mapimages', 'src').to_s
TILEINDEX_DIR = Rails.root.join('db/maptileindex').to_s

#if gdal is not on the normal path
GDAL_PATH = ''

# To prevent legacy errors looking to obsolete APP_CONFIG constant
APP_CONFIG = {}

AppConfig = OpenStruct.new

AppConfig.city = ENV['APP_PLACE_CITY'] || "Ithaca"
AppConfig.state = ENV['APP_PLACE_STATE'] || "NY"
AppConfig.organization = ENV['APP_ORG_NAME'] || "The History Center in Tompkins County"
AppConfig.url = ENV['APP_ORG_URL'] || "https://thehistorycenter.net"
AppConfig.latitude = ENV['APP_LATITUDE'] || 42.4418353
AppConfig.longitude = ENV['APP_LONGITUDE'] || -76.4987984

#
# Uncomment and populate the config file if you want to enable:
# MAX_DIMENSION = will reduce the dimensions of the image when uploaded
# MAX_ATTACHMENT_SIZE = will reject files that are bigger than this
# GDAL_MEMORY_LIMIT = limit the amount of memory available to gdal
#
#MAX_DIMENSION = APP_CONFIG['max_dimension']
#MAX_ATTACHMENT_SIZE = APP_CONFIG['max_attachment_size']
#GDAL_MEMORY_LIMIT = APP_CONFIG['gdal_memory_limit']


# ActionMailer::Base.default_url_options[:host] = APP_CONFIG['host']
# ActionMailer::Base.delivery_method = :sendmail
# Devise.mailer_sender = APP_CONFIG['email']
