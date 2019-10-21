Geocoder.configure(
  timeout: 2,
  use_https: true,
  lookup: :google,
  api_key: AppConfig.geocoding_key
)
