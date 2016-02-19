require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'dotenv'
Dotenv.load('.env', ".env.#{Rails.env}")

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails4Mapwarper
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.filter_parameters += [:password, :password_confirmation]

    config.quiet_assets = true
    config.logger = Logger.new(STDOUT)

    config.action_mailer.default_url_options = { host: ENV['BASE_URL'] }
    config.action_mailer.smtp_settings = {
        address:        ENV['SMTP_HOST'],
        port:           ENV['SMTP_PORT'],
        user_name:      ENV['SMTP_USERNAME'],
        password:       ENV['SMTP_PASSWORD']
    }

  end
end
