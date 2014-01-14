if CONFIG['airbrake']
  Airbrake.configure do |config|
    config.api_key = CONFIG['airbrake']['api_key']
    config.host    = CONFIG['airbrake']['host']
    config.port    = 80
    config.secure  = config.port == 443
  end
end